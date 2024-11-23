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
    
    init() {
        self.user_id = UserDefaults.standard.string(forKey: "uid") ?? ""
        self.users_db = db.collection("users")
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

    // Send email verification
    func send_email_verification(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is logged in."])
            completion(.failure(error))
            return
        }
        
        // Check if email is already verified
        if currentUser.isEmailVerified {
            completion(.success(()))
        } else {
            // Send verification email
            currentUser.sendEmailVerification { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                // Notify the caller of success
                completion(.success(()))
            }
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
}
