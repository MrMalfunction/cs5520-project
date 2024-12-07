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
                    if let businessID = document.data()["name"] as? String {
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
    
//    func fetchAvailableHospitalNames(completion: @escaping (Result<[String], Error>) -> Void) {
//        // Fetch the current user's document first
//        let userRef = users_db.document(self.user_id) // `self.user_id` should already hold the current user ID
//        userRef.getDocument { userDocument, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            // Ensure the user document exists
//            guard let userData = userDocument?.data(),
//                  let linkedHospitals = userData["linkedHospitals"] as? [String] else {
//                completion(.failure(NSError(
//                    domain: "FirestoreError",
//                    code: -2,
//                    userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve linked hospitals for the user."]
//                )))
//                return
//            }
//            
//            // Now query for hospitals
//            self.users_db.whereField("userType", isEqualTo: "Hospital").getDocuments { querySnapshot, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                // Ensure the snapshot is valid
//                guard let snapshot = querySnapshot else {
//                    completion(.failure(NSError(
//                        domain: "FirestoreError",
//                        code: -1,
//                        userInfo: [NSLocalizedDescriptionKey: "No hospitals found"]
//                    )))
//                    return
//                }
//                
//                // Filter out hospitals already in the `linkedHospitals` array
//                var availableHospitals: [String] = []
//                for document in snapshot.documents {
//                    if let hospitalName = document.data()["name"] as? String,
//                       !linkedHospitals.contains(hospitalName) { // Check the `name` field against `linkedHospitals`
//                        availableHospitals.append(hospitalName)
//                    }
//                }
//
//                
//                // Return the filtered results
//                completion(.success(availableHospitals))
//            }
//        }
//    }
    
    func fetchAvailableHospitalNames(completion: @escaping (Result<[String], Error>) -> Void) {
        // Fetch the current user's document first
        let userRef = users_db.document(self.user_id) // `self.user_id` should already hold the current user ID
        userRef.getDocument { userDocument, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if the user's document exists and try to retrieve linked hospitals
            let linkedHospitals = (userDocument?.data()?["linkedHospitals"] as? [String]) ?? []
            
            // Now query for all hospitals
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
                
                // Prepare the list of available hospitals
                var availableHospitals: [String] = []
                for document in snapshot.documents {
                    if let hospitalName = document.data()["name"] as? String {
                        // Add to the list only if it's not in linkedHospitals (or skip filtering if linkedHospitals is empty)
                        if linkedHospitals.isEmpty || !linkedHospitals.contains(hospitalName) {
                            availableHospitals.append(hospitalName)
                        }
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
    
    func updateUserInInsurer(currentInsName: String, newInsName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Step 1: Remove user from the current insurer only if the currentInsName is not "N/A"
        if currentInsName != "N/A" {
            self.insurersRecords.whereField("name", isEqualTo: currentInsName).getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No insurer found with the name \(currentInsName).")
                    completion(.failure(NSError(domain: "CurrentInsurerNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "No insurer found with the name \(currentInsName)."])))
                    return
                }

                let currentInsurerDocument = documents.first
                currentInsurerDocument?.reference.updateData([
                    "linkedPatients": FieldValue.arrayRemove([self.user_id])
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    // Proceed to step 2: Add user to the new insurer
                    self.updateNewInsurer(newInsName: newInsName, completion: completion)
                }
            }
        } else {
            // If the current insurer is "N/A", skip removal and just update the new insurer
            self.updateNewInsurer(newInsName: newInsName, completion: completion)
        }
    }

    // Helper method to update the new insurer
    private func updateNewInsurer(newInsName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.insurersRecords.whereField("name", isEqualTo: newInsName).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No insurer found with the name \(newInsName).")
                completion(.failure(NSError(domain: "NewInsurerNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "No insurer found with the name \(newInsName)."])))
                return
            }

            let newInsurerDocument = documents.first
            newInsurerDocument?.reference.updateData([
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
    
    func fetchCurrentHopsPatientsDetails(completion: @escaping (Result<[(name: String, email: String, profileImage: String, uid: String, linkedHospitals: [String])], Error>) -> Void) {
        // Get the current hospital username from UserDefaults
        guard let currentHospitalUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(.failure(NSError(
                domain: "UserError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Current hospital username not found."]
            )))
            return
        }

        // Query for all users where userType is "Patient"
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

            var patients: [(name: String, email: String, profileImage: String, uid: String, linkedHospitals: [String])] = []

            for document in snapshot.documents {
                if let name = document.data()["name"] as? String,
                   let email = document.data()["email"] as? String,
                   let linkedHospitals = document.data()["linkedHospitals"] as? [String], // Check linked hospitals
                   linkedHospitals.contains(currentHospitalUsername) { // Ensure the hospital is linked to the patient
                    let profileImage = document.data()["profileImage"] as? String ?? "DefaultProfileImageURL"
                    let uid = document.documentID
                    let linkedHospitals = document.data()["linkedInsurers"] as? [String] ?? [] // Add linked hospitals

                    patients.append((name: name, email: email, profileImage: profileImage, uid: uid, linkedHospitals: linkedHospitals))
                }
            }

            print("Fetched \(patients.count) patients linked to \(currentHospitalUsername).")
            completion(.success(patients))
        }
    }
    
    func fetchCurrentInsurerPatientsDetails(completion: @escaping (Result<[(name: String, email: String, profileImage: String, uid: String, linkedHospitals: [String])], Error>) -> Void) {
        // Get the current insurer username from UserDefaults
        guard let currentInsurerUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(.failure(NSError(
                domain: "UserError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Current Insurer username not found."]
            )))
            return
        }

        // Query for all users where userType is "Patient"
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

            var patients: [(name: String, email: String, profileImage: String, uid: String, linkedHospitals: [String])] = []

            for document in snapshot.documents {
                if let name = document.data()["name"] as? String,
                   let email = document.data()["email"] as? String,
                   let linkedInsurers = document.data()["linkedInsurers"] as? [String], // Check linked insurers
                   linkedInsurers.contains(currentInsurerUsername) {
                    let profileImage = document.data()["profileImage"] as? String ?? "DefaultProfileImageURL"
                    let uid = document.documentID
                    let linkedHospitals = document.data()["linkedHospitals"] as? [String] ?? [] // Add linked hospitals
                    patients.append((name: name, email: email, profileImage: profileImage, uid: uid, linkedHospitals: linkedHospitals))
                }
            }

            print("Fetched \(patients.count) patients linked to \(currentInsurerUsername).")
            completion(.success(patients))
        }
    }

    
    func fetchDetailsAdd_Contact(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Fetch the current user's document
        let userRef = users_db.document(self.user_id) // `self.user_id` should already hold the current hospital's UID
        userRef.getDocument { userDocument, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Ensure the document exists and retrieve its data
            guard let document = userDocument, document.exists, let data = document.data() else {
                completion(.failure(NSError(
                    domain: "FirestoreError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Details not found."]
                )))
                return
            }

            // Return the hospital data
            completion(.success(data))
        }
    }






}
