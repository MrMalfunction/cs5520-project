//
//  FirestoreGenericHelpers.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/4/24.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreGenericHelpers {
    private let db = Firestore.firestore()
    private let users_db: FirebaseFirestore.CollectionReference
    private var user_id: String
    private let medicalRecordsDB: CollectionReference
    private let accessRequestsDB: CollectionReference
    
    private let hospitalRecords: CollectionReference
    private let insurersRecords: CollectionReference
    
    init() {
        self.user_id = UserDefaults.standard.string(forKey: "uid") ?? ""
        self.users_db = db.collection("users")
        self.medicalRecordsDB = db.collection("medicalRecords")
        self.accessRequestsDB = db.collection("accessRequests")
        
        self.hospitalRecords = db.collection("hospitalRecords")
        self.insurersRecords = db.collection("insurersRecords")
    }
    
    func saveProfileImageToFirestore(image: UIImage, completion: @escaping (Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.20) else {
            print("Failed to convert image to JPEG data.")
            return
        }
        
        let base64String = imageData.base64EncodedString()
        let userRef = db.collection("users").document(self.user_id)
        
        userRef.updateData([
            "profileImage": base64String
        ]) { error in
            completion(error)
        }
    }
    
    func fetchBusinessIDsForInsuranceCompanies(completion: @escaping (Result<[String], Error>) -> Void) {
        users_db
            .whereField("userType", isEqualTo: "Insurance Company")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
                    return
                }
                
                var businessIDs: [String] = []
                for document in snapshot.documents {
                    if let businessID = document.data()["businessID"] as? String {
                        businessIDs.append(businessID)
                    }
                }
                
                if businessIDs.isEmpty {
                    let sampleBusinessIDs = ["sampleID1", "sampleID2", "sampleID3"]
                    completion(.success(sampleBusinessIDs))
                } else {
                    completion(.success(businessIDs))
                }
            }
    }
    
    func removeHospitalFromUser (hospital: String, completion: @escaping (Result<Void, Error>) -> Void) {
                
        self.db.collection("hospitalRecords")
            .whereField("name", isEqualTo: hospital)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No document found with the name 'Hosp1'.")
                    return
                }
                
                for document in documents {
                    document.reference.updateData([
                        "linkedPatients": FieldValue.arrayRemove([self.user_id])
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Successfully removed \(self.user_id) from linkedPatients if it existed.")
                        }
                    }
                }
            }

        
        let userRef = users_db.document(self.user_id)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  var linkedHospitals = document.data()?["linkedHospitals"] as? [String],
                  let index = linkedHospitals.firstIndex(of: hospital) else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Hospital not found"])))
                return
            }
            
            linkedHospitals.remove(at: index)
            
            userRef.updateData(["linkedHospitals": linkedHospitals]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func fetchAvailableHospitalNames(completion: @escaping (Result<[String], Error>) -> Void) {
        // Fetch the current user's document first
        let userRef = users_db.document(self.user_id) // `self.user_id` should already hold the current user ID
        userRef.getDocument { userDocument, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure the user document exists
            guard let userData = userDocument?.data(),
                  let linkedHospitals = userData["linkedHospitals"] as? [String] else {
                completion(.failure(NSError(
                    domain: "FirestoreError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve linked hospitals for the user."]
                )))
                return
            }
            
            // Now query for hospitals
            self.users_db.whereField("userType", isEqualTo: "Hospital").getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Ensure the snapshot is valid
                guard let snapshot = querySnapshot else {
                    completion(.failure(NSError(
                        domain: "FirestoreError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No hospitals found"]
                    )))
                    return
                }
                
                // Filter out hospitals already in the `linkedHospitals` array
                var availableHospitals: [String] = []
                for document in snapshot.documents {
                    if let hospitalName = document.data()["name"] as? String,
                       !linkedHospitals.contains(hospitalName) { // Check the `name` field against `linkedHospitals`
                        availableHospitals.append(hospitalName)
                    }
                }

                
                // Return the filtered results
                completion(.success(availableHospitals))
            }
        }
    }
    
    func addHospital(hospitalName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.users_db.document(self.user_id).updateData([
            "linkedHospitals": FieldValue.arrayUnion([hospitalName])
        ]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Step 2: Add the user ID to the linkedPatients array in the hospital's document
            self.hospitalRecords.whereField("name", isEqualTo: hospitalName).getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No hospital found with the name \(hospitalName).")
                    completion(.failure(NSError(domain: "HospitalNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "No hospital found with the name \(hospitalName)."])))
                    return
                }
                
                // Assuming only one hospital matches the name
                let hospitalDocument = documents.first
                hospitalDocument?.reference.updateData([
                    "linkedPatients": FieldValue.arrayUnion([self.user_id])
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }


}
