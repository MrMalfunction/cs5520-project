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
    
    init() {
        self.user_id = UserDefaults.standard.string(forKey: "uid") ?? ""
        self.users_db = db.collection("users")
        self.medicalRecordsDB = db.collection("medicalRecords")
        self.accessRequestsDB = db.collection("accessRequests")
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
    
    func removeHospitalFromUser(_ hospital: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // TODO: Remove user id from hospital collection too
        
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

}
