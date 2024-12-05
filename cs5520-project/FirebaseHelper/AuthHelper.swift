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
    
    func reset_password(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func login_check() -> Bool {
        if Auth.auth().currentUser != nil{
            return true
        } else {
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "userType")
            UserDefaults.standard.removeObject(forKey: "email")
            return false
        }
    }
    
    func login_user(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Perform Firebase Authentication login
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let userError: NSError
                
                // Handle network-related errors
                if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut {
                    userError = NSError(domain: "", code: error.code, userInfo: [NSLocalizedDescriptionKey: "Network error. Please check your connection and try again."])
                } else {
                    // Handle authentication error
                    userError = NSError(domain: "", code: error.code, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password. Please try again."])
                }
                
                completion(.failure(userError))
                return
            }
            
            // Ensure we have a valid user
            guard let user = authResult?.user else {
                let noUserError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user."])
                completion(.failure(noUserError))
                return
            }

            // Query Firestore for the user's data
            self.users_db.document(user.uid).getDocument { document, error in
                if let error = error {
                    // Handle Firestore query error
                    completion(.failure(error))
                    return
                }
                
                // Handle the case where no document was found
                guard let document = document, document.exists else {
                    let userNotFoundError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found in the database."])
                    completion(.failure(userNotFoundError))
                    return
                }
                
                // Extract user details from Firestore document
                if let userType = document.get("userType") as? String {
                    // Save the user information to UserDefaults
                    UserDefaults.standard.set(user.uid, forKey: "uid")
                    UserDefaults.standard.set(userType, forKey: "userType")
                    UserDefaults.standard.set(document.get("email"), forKey: "email")
                    UserDefaults.standard.set(document.get("name"), forKey: "username")
                    
                    // Successful login
                    completion(.success(()))
                } else {
                    // Handle case where userType is missing in the document
                    let missingFieldError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User type is missing in user data."])
                    completion(.failure(missingFieldError))
                }
            }
        }
    }
        
        
        func logout_user(completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                UserDefaults.standard.removeObject(forKey: "uid")
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "userType")
                UserDefaults.standard.removeObject(forKey: "email")
                try Auth.auth().signOut()
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }

        
        func register_user(name: String, email: String, password: String, userType: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().createUser(withEmail: email.lowercased(), password: password) { authResult, error in
                if let error = error as NSError? {
                    completion(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user."])))
                    return
                }
                
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "name": name,
                    "email": email.lowercased(),
                    "userType": userType
                ]
                
                self.users_db.document(user.uid).setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        UserDefaults.standard.set(name, forKey: "username")
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(user.uid, forKey: "uid")
                        UserDefaults.standard.set(userType, forKey: "userType")
                        UserDefaults.standard.synchronize()
                        completion(.success(()))
                    }
                }
            }
        }
        
        func check_business_name(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
            users_db.whereField("name", isEqualTo: name).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                    completion(.failure(NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "Business name is already taken."])))
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
        func fetchUserData( completion: @escaping (Result<[UserProfileKey: Any], Error>) -> Void) {
        let db = Firestore.firestore()
        
        // Query the Firestore database for the user based on the provided UID
            db.collection("users").document(self.user_id).getDocument { document, error in
            if let error = error {
                // Handle error (e.g., network issues or Firestore errors)
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                // Handle case where the document does not exist
                let notFoundError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found."])
                completion(.failure(notFoundError))
                return
            }
            
            // Parse the document data
            var userProfileData = [UserProfileKey: Any]()
            
            // Map each field from the document to the enum keys
            if let email = document.get(UserProfileKey.email.rawValue) as? String {
                userProfileData[.email] = email
            }
            
            if let name = document.get(UserProfileKey.name.rawValue) as? String {
                userProfileData[.name] = name
            }
            
            if let uid = document.get(UserProfileKey.uid.rawValue) as? String {
                userProfileData[.uid] = uid
            }
            
            if let userType = document.get(UserProfileKey.userType.rawValue) as? String {
                userProfileData[.userType] = userType
            }
            
            // Optionally, check for linkedHospitals or linkedInsurers as arrays
            if let linkedHospitals = document.get(UserProfileKey.linkedHospitals.rawValue) as? [String] {
                userProfileData[.linkedHospitals] = linkedHospitals
            }
            
            if let linkedInsurers = document.get(UserProfileKey.linkedInsurers.rawValue) as? [String] {
                userProfileData[.linkedInsurers] = linkedInsurers
            }
                
            if let profilePhoto = document.get(UserProfileKey.profileImage.rawValue) as? String {
                userProfileData[.profileImage] = profilePhoto
            }
            
            // Return the data via completion handler
            completion(.success(userProfileData))
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
