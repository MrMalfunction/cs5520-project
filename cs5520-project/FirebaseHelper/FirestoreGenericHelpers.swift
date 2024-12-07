
import FirebaseFirestore
import FirebaseAuth

class FirestoreGenericHelpers {
    private let db = Firestore.firestore()
    private let users_db: FirebaseFirestore.CollectionReference
    private var user_id: String
    private let medicalRecordsDB: CollectionReference    
    private let hospitalRecords: CollectionReference
    private let insurersRecords: CollectionReference
    private let approveRequest: CollectionReference
    
    init() {
        self.user_id = UserDefaults.standard.string(forKey: "uid") ?? ""
        self.users_db = db.collection("users")
        self.medicalRecordsDB = db.collection("medicalRecords")
        
        self.hospitalRecords = db.collection("hospitalRecords")
        self.insurersRecords = db.collection("insurersRecords")
        self.approveRequest = db.collection("approveRequest")
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
    
    func fetchHospitalsWithAddresses(completion: @escaping (Result<[String: String], Error>) -> Void) {
        // Query for all hospitals
        users_db.whereField("userType", isEqualTo: "Hospital").getDocuments { querySnapshot, error in
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
            
            // Prepare the key-value dictionary of hospital names and addresses
            var hospitalsWithAddresses: [String: String] = [:]
            
            for document in snapshot.documents {
                let data = document.data()
                if
                    let hospitalName = data["name"] as? String,
                    let address = data["address"] as? String,
                    !address.isEmpty
                {
                    hospitalsWithAddresses[hospitalName] = address
                }
            }
            
            // Return the results
            completion(.success(hospitalsWithAddresses))
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
    
    func addMedicalRecord(recordType: String, value: String, comments: String, enteredBy: String, patientId: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        // Get the current timestamp
        let timestamp = Timestamp(date: Date())
        
        // Determine the patient ID to use
        let targetPatientId = patientId ?? self.user_id

        // Prepare the data to be saved
        let recordData: [String: Any] = [
            "enteredBy": enteredBy,    // Who entered the record (e.g., "IfReq")
            "patientId": targetPatientId,  // Use the provided patient ID or fallback to self.user_id
            "recordType": recordType,   // Type of the record (e.g., "Blood Glucose Level")
            "timestamp": timestamp,     // Current timestamp
            "value": value,             // The value for the medical record (e.g., "UserValue")
            "comments": comments        // Additional comments for the medical record
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
    
    func addApproveRequest(status: String, comments: String, insurerName: String, patientName: String, patientId: String, hospitalName: String, hospitalId: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        // Get the current timestamp
        let timestamp = Timestamp(date: Date())
        


        // Prepare the data to be saved
        let recordData: [String: Any] = [
            "Status": status,
            "comments": comments,
            "insurerName": insurerName,
            "PatientName": patientName,
            "patientId": patientId,
            "Date": timestamp,
            "hospitalName": hospitalName,
            "hospitalId": hospitalId
        ]
        
        // Add the record to the Firestore database
        approveRequest.addDocument(data: recordData) { error in
            if let error = error {
                completion(.failure(error))  // Handle any errors that occur during the save
            } else {
                completion(.success(()))     // Success - record saved
            }
        }
    }
    
    func fetchApproveRequests(insurerName: String, patientId: String, completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void) {
        // Perform a Firestore query where insurerName and patientId match the provided values
        approveRequest.whereField("insurerName", isEqualTo: insurerName)
            .whereField("patientId", isEqualTo: patientId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // Pass the error to the completion handler
                    completion(.failure(error))
                } else if let querySnapshot = querySnapshot {
                    // Pass the documents to the completion handler
                    completion(.success(querySnapshot.documents))
                }
            }
    }
    func fetchApproveRequestsHospital(hospitalName: String, patientId: String, completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void) {
        // Perform a Firestore query where insurerName and patientId match the provided values
        approveRequest.whereField("hospitalName", isEqualTo: hospitalName)
            .whereField("patientId", isEqualTo: patientId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // Pass the error to the completion handler
                    completion(.failure(error))
                } else if let querySnapshot = querySnapshot {
                    // Pass the documents to the completion handler
                    completion(.success(querySnapshot.documents))
                }
            }
    }
    
    func fetchApproveRequestsPatient(patientId: String, completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void) {
        // Perform a Firestore query where insurerName and patientId match the provided values
        approveRequest.whereField("patientId", isEqualTo: patientId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // Pass the error to the completion handler
                    completion(.failure(error))
                } else if let querySnapshot = querySnapshot {
                    // Pass the documents to the completion handler
                    completion(.success(querySnapshot.documents))
                }
            }
    }




    func fetchMedicalRecordsForPatient(patientId: String? = nil, completion: @escaping (Result<[MedicalRecord], Error>) -> Void) {
        // Create a DateFormatter to format the timestamp as a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm:ss a z" // Adjust the format as needed
        
        // Determine which patientId to use
        let targetPatientId = patientId ?? self.user_id
        
        // Query the medicalRecords collection to get all records for the specified patientId
        medicalRecordsDB
            .whereField("patientId", isEqualTo: targetPatientId)
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
                        
                        // Fetch comments if they exist, or set to an empty string
                        let comments = data["comments"] as? String ?? ""
                        //print("tiemstamap is \(timestampString)")
                        
                        // Create a MedicalRecord object with the timestamp as a string
                        let record = MedicalRecord(
                            enteredBy: enteredBy,
                            patientId: patientId,
                            recordType: recordType,
                            timestamp: timestampString, // Use the formatted string
                            value: value,
                            comments: comments // Include comments
                        )
                        medicalRecords.append(record)
                    }
                }
                
                medicalRecords.sort { record1, record2 in
                    guard let date1 = dateFormatter.date(from: record1.timestamp),
                          let date2 = dateFormatter.date(from: record2.timestamp) else {
                        return false // Fallback to maintaining the order if dates are invalid
                    }
                    return date1 > date2 // Latest date first
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


    
    func updateRequestStatusInFirestore(patientName: String, hospitalName: String, comments: String, newStatus: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Perform a Firestore query to find the document that matches the given fields
        approveRequest.whereField("PatientName", isEqualTo: patientName)
            .whereField("hospitalName", isEqualTo: hospitalName)
            .whereField("comments", isEqualTo: comments)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // Pass the error to the completion handler
                    completion(.failure(error))
                } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                    // Assuming there's only one matching document (handle multiple matches if needed)
                    if let document = querySnapshot.documents.first {
                        // Update the status field of the document
                        document.reference.updateData(["Status": newStatus]) { updateError in
                            if let updateError = updateError {
                                completion(.failure(updateError)) // Pass update error
                            } else {
                                completion(.success(())) // Update was successful
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching document found"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching document found"])))
                }
            }
    }

}
