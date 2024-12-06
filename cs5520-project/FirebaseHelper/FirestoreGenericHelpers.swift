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
    private let hospitalRecords: CollectionReference
    private let insurersRecords: CollectionReference
    
    init() {
        self.user_id = UserDefaults.standard.string(forKey: "uid") ?? ""
        self.users_db = db.collection("users")
        self.medicalRecordsDB = db.collection("medicalRecords")
        
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
    
    func addMedicalRecord(recordType: String, value: String, enteredBy: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Get the current timestamp
        let timestamp = Timestamp(date: Date())
        
        // Prepare the data to be saved
        let recordData: [String: Any] = [
            "enteredBy": enteredBy,    // Who entered the record (e.g., "IfReq")
            "patientId": self.user_id,  // Use the current user ID as patient ID
            "recordType": recordType,   // Type of the record (e.g., "Blood Glucose Level")
            "timestamp": timestamp,     // Current timestamp
            "value": value              // The value for the medical record (e.g., "UserValue")
        ]
        
        // Add the record to the Firestore database
        medicalRecordsDB.addDocument(data: recordData) { error in
            if let error = error {
                completion(.failure(error))  // Handle any errors that occur during the save
            } else {
                completion(.success(()))     // Success - record saved
            }
        }
    }

    func fetchMedicalRecordsForPatient(completion: @escaping (Result<[MedicalRecord], Error>) -> Void) {
        // Create a DateFormatter to format the timestamp as a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy at h:mm:ss a z" // Adjust the format as needed

        // Query the medicalRecords collection to get all records where patientId equals self.user_id
        medicalRecordsDB
            .whereField("patientId", isEqualTo: self.user_id)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Ensure there are results
                guard let snapshot = querySnapshot, !snapshot.documents.isEmpty else {
                    completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No medical records found for this patient."])))
                    return
                }
                
                var medicalRecords: [MedicalRecord] = []
                
                // Parse documents into MedicalRecord models
                for document in snapshot.documents {
                    let data = document.data()
                    
                    // Assuming 'MedicalRecord' is a model struct you defined to hold the details
                    if let enteredBy = data["enteredBy"] as? String,
                       let patientId = data["patientId"] as? String,
                       let recordType = data["recordType"] as? String,
                       let timestamp = data["timestamp"] as? Timestamp,
                       let value = data["value"] as? String {
                        
                        // Convert the timestamp to a string using the DateFormatter
                        let timestampString = dateFormatter.string(from: timestamp.dateValue())
                        
                        // Create a MedicalRecord object with the timestamp as a string
                        let record = MedicalRecord(
                            enteredBy: enteredBy,
                            patientId: patientId,
                            recordType: recordType,
                            timestamp: timestampString, // Use the formatted string
                            value: value
                        )
                        medicalRecords.append(record)
                    }
                }
                
                // Return the fetched records
                completion(.success(medicalRecords))
            }
    }
    
    func fetchAllPatientsDetails(completion: @escaping (Result<[(name: String, email: String, profileImage: String, uid: String)], Error>) -> Void) {
        self.users_db.whereField("userType", isEqualTo: "Patient").getDocuments(source: .server) { querySnapshot, error in
            if let error = error {
                print("Error fetching patients: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let snapshot = querySnapshot else {
                print("No patients found.")
                completion(.failure(NSError(
                    domain: "FirestoreError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No patients found"]
                )))
                return
            }

            var patients: [(name: String, email: String, profileImage: String, uid: String)] = []
            for document in snapshot.documents {
                if let name = document.data()["name"] as? String,
                   let email = document.data()["email"] as? String {
                    let profileImage = document.data()["profileImage"] as? String ?? "DefaultProfileImageURL"
                    let uid = document.documentID
                    patients.append((name: name, email: email, profileImage: profileImage, uid: uid))
                }
            }

            print("Fetched \(patients.count) patients.")
            completion(.success(patients))
        }
    }




}
