//
//  AuthHelper.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/22/24.
//

import FirebaseFirestore
import FirebaseAuth

class AuthHelper {
    // Firestore database instance
    private let db = Firestore.firestore()
    // Reference to the "users" collection in Firestore
    private let users_db: FirebaseFirestore.CollectionReference
    // The currently logged-in user's UID, stored locally
    private var user_id: String
    
    // Initializer to set up the Firestore collection and retrieve the user ID from UserDefaults
    init() {
        self.user_id = UserDefaults.standard.string(forKey: "uid") ?? "" // Retrieve UID if it exists
        self.users_db = db.collection("users") // Reference to "users" Firestore collection
    }
    
    /**
     Logs in a user with the provided email and password.
     
     - Parameters:
        - email: The user's email address.
        - password: The user's password.
        - completion: A closure that returns a `Result` indicating success or failure.
     */
    func login_user(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // Handle error if login fails
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure we have a valid user object
            guard let user = authResult?.user else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user ID"])
                completion(.failure(error))
                return
            }
            
            // Save user ID to UserDefaults for future sessions
            UserDefaults.standard.set(user.uid, forKey: "uid")
            completion(.success(())) // Notify the caller of success
        }
    }
    
    /**
     Logs out the current user by signing them out and clearing their stored UID.
     
     - Parameters:
        - completion: A closure that returns a `Result` indicating success or failure.
     */
    func logout_user(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            // Attempt to sign the user out of Firebase
            try Auth.auth().signOut()
            // Remove the user's UID from UserDefaults
            UserDefaults.standard.removeObject(forKey: "uid")
            completion(.success(())) // Notify the caller of success
        } catch let error {
            completion(.failure(error)) // Notify the caller of any errors
        }
    }
    
    /**
     Registers a new user with Firebase Authentication and creates a user record in Firestore.
     
     - Parameters:
        - name: The user's full name.
        - email: The user's email address (automatically converted to lowercase).
        - password: The user's password.
        - userType: A custom field indicating the user's role/type.
        - completion: A closure that returns a `Result` indicating success or failure.
     */
    func register_user(name: String, email: String, password: String, userType: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Create a new Firebase Authentication user
        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { authResult, error in
            // Handle error if registration fails
            if let error = error as NSError? {
                completion(.failure(error))
                return
            }
            
            // Ensure we have a valid user object
            guard let user = authResult?.user else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user ID"])
                completion(.failure(error))
                return
            }
            
            // Save user ID to UserDefaults and update the local user_id property
            UserDefaults.standard.set(user.uid, forKey: "uid")
            self.user_id = user.uid
            
            // Create a dictionary of user data to save in Firestore
            let userData: [String: Any] = [
                "uid": user.uid,             // User ID
                "email": email.lowercased(), // Lowercase email for consistency
                "userType": userType,        // User role/type
                "name": name                 // User's full name
            ]
            
            // Save the user data in Firestore under the user's UID
            self.users_db.document(user.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error)) // Notify the caller if saving to Firestore fails
                } else {
                    completion(.success(())) // Notify the caller of success
                }
            }
        }
    }
}
