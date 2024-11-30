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

    func reset_password(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    func login_user(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                completion(.failure(error))
                return
            }

            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user."])))
                return
            }

            self.users_db.document(user.uid).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = document, document.exists, let data = document.data() else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found."])))
                    return
                }

                if let name = data["name"] as? String {
                    UserDefaults.standard.set(name, forKey: "username")
                }
                if let email = data["email"] as? String {
                    UserDefaults.standard.set(email, forKey: "email")
                }
                if let userType = data["userType"] as? String {
                    UserDefaults.standard.set(userType, forKey: "userType")
                }

                UserDefaults.standard.set(user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                completion(.success(()))
            }
        }
    }

    func logout_user(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "userType")
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
}
