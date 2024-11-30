//
//  AuthHelper.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/22/24.
//

import FirebaseFirestore
import FirebaseAuth

class AuthHelper {
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

    // Reset password function
    func reset_password(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Notify the caller of success
            completion(.success(()))
        }
    }
    
    // Login function
    func login_user(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let userError: NSError
                
                if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut {
                    userError = NSError(domain: "", code: error.code, userInfo: [NSLocalizedDescriptionKey: "Network error. Please check your connection and try again."])
                } else {
                    userError = NSError(domain: "", code: error.code, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password. Please try again."])
                }
                
                completion(.failure(userError))
                return
            }
            
            guard let user = authResult?.user else {
                let retrievalError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user. Please try again."])
                completion(.failure(retrievalError))
                return
            }
            
            self.users_db.whereField("uid", isEqualTo: user.uid).getDocuments { (querySnapshot, error) in
                if let error = error {
                    // Handle Firestore query error
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    // Handle case where no user is found
                    let notFoundError = NSError(
                        domain: "",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "User not found. Please check the UID."]
                    )
                    completion(.failure(notFoundError))
                    return
                }
                
                // Assuming there is only one user document for the given UID
                let document = documents.first
                if let userType = document?.get("userType") as? String {
                    // Store the userType in UserDefaults
                    UserDefaults.standard.set(userType, forKey: "userType")
                    completion(.success(()))
                } else {
                    // Handle case where the userType field is missing
                    let missingFieldError = NSError(
                        domain: "",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "UserType field is missing for this user."]
                    )
                    completion(.failure(missingFieldError))
                }
            }
            
            UserDefaults.standard.set(user.uid, forKey: "uid")
            completion(.success(()))
        }
    }

    // Logout function
    func logout_user(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "uid")
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    // Register user function
    func register_user(name: String, email: String, password: String, userType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { authResult, error in
            if let error = error as NSError? {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user ID"])
                completion(.failure(error))
                return
            }
            
            UserDefaults.standard.set(user.uid, forKey: "uid")
            self.user_id = user.uid
            
            let userData: [String: Any] = [
                "uid": user.uid,
                "email": email.lowercased(),
                "userType": userType,
                "name": name
            ]
            
            self.users_db.document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // Check business name
    func check_business_name(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        users_db.whereField("name", isEqualTo: name).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                let error = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "Business name is already taken."])
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Function to save patient data to the Firestore database
    func savePatientData(patientData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        // Generate a unique document ID for the patient record
        let documentID = medicalRecordsDB.document().documentID
        
        // Set the data in the medicalRecords collection
        medicalRecordsDB.document(documentID).setData(patientData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Grant access to hospital
     func grantAccessToHospital(hospitalCode: String, requestType: String, completion: @escaping (Result<Void, Error>) -> Void) {
         guard !user_id.isEmpty else {
             completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
             return
         }

         let accessData: [String: Any] = [
             "approvedByPatient": true,
             "patientId": user_id,
             "requestType": requestType,
             "requestedBy": hospitalCode,
             "status": "approved",
             "timestamp": FieldValue.serverTimestamp()
         ]

         // Save access request to Firestore
         accessRequestsDB.document().setData(accessData) { error in
             if let error = error {
                 completion(.failure(error))
             } else {
                 completion(.success(()))
             }
         }
     }
    
    
//    // Fetch all hospitals that the patient has granted access to
//     func fetchGrantedAccess(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
//         guard !user_id.isEmpty else {
//             completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
//             return
//         }
//
//         accessRequestsDB.whereField("patientId", isEqualTo: user_id).whereField("status", isEqualTo: "approved").getDocuments { (querySnapshot, error) in
//             if let error = error {
//                 completion(.failure(error))
//                 return
//             }
//             let accessList = querySnapshot?.documents.map { $0.data().merging(["id": $0.documentID]) { _, new in new } } ?? []
//             completion(.success(accessList))
//         }
//     }
//
//     // Remove access for a specific hospital
//     func revokeAccess(requestID: String, completion: @escaping (Result<Void, Error>) -> Void) {
//         accessRequestsDB.document(requestID).updateData(["status": "revoked"]) { error in
//             if let error = error {
//                 completion(.failure(error))
//             } else {
//                 completion(.success(()))
//             }
//         }
//     }
    
    // Fetch hospitals granted access
     func fetchGrantedAccess(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
         let userId = UserDefaults.standard.string(forKey: "uid") ?? ""
         accessRequestsDB.whereField("patientId", isEqualTo: userId)
             .whereField("approvedByPatient", isEqualTo: true)
             .getDocuments { snapshot, error in
                 if let error = error {
                     completion(.failure(error))
                     return
                 }
                 let hospitals = snapshot?.documents.compactMap { $0.data() } ?? []
                 completion(.success(hospitals))
             }
     }

     // Revoke access for a hospital
     func revokeAccess(hospitalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
         let userId = UserDefaults.standard.string(forKey: "uid") ?? ""
         accessRequestsDB.whereField("patientId", isEqualTo: userId)
             .whereField("requestedBy", isEqualTo: hospitalId)
             .getDocuments { snapshot, error in
                 if let error = error {
                     completion(.failure(error))
                     return
                 }
                 guard let document = snapshot?.documents.first else {
                     completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Record not found."])))
                     return
                 }
                 document.reference.updateData(["approvedByPatient": false, "status": "revoked"]) { error in
                     if let error = error {
                         completion(.failure(error))
                     } else {
                         completion(.success(()))
                     }
                 }
             }
     }
    
    
    // Fetch user data
    func fetchUserData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard !user_id.isEmpty else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }
        
        users_db.document(user_id).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let userData = document.data() ?? [:]
                completion(.success(userData))
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found."])))
            }
        }
    }

    // Update user data
    func updateUserData(data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard !user_id.isEmpty else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }
        
        users_db.document(user_id).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
