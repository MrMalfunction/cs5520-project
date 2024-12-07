import FirebaseFirestore
import FirebaseAuth

class AuthHelper {
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
    
    func registerNewHospital(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Create a reference to the Firestore collection
        
        // Prepare the new hospital data
        let hospitalData: [String: Any] = [
            "name": name,
            "linkedPatients": []
        ]
        
        // Add the new hospital to Firestore
        self.hospitalRecords.addDocument(data: hospitalData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func registerNewInsurance(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Create a reference to the Firestore collection
        let insurersCollection = self.db.collection("insurersRecords")
        
        // Prepare the new insurance data (change the data structure as needed for insurance)
        let insuranceData: [String: Any] = [
            "name": name,
            "linkedPatients": []  // Adjust based on how you want to link patients to insurers
        ]
        
        // Add the new insurance record to Firestore
        insurersCollection.addDocument(data: insuranceData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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
        
    
    func fetchUserData(patientId: String? = nil, completion: @escaping (Result<[UserProfileKey: Any], Error>) -> Void) {
        let db = Firestore.firestore()
        print("Patient id in fetchUserData: \(patientId ?? "")")
        // Use the provided patientId or fallback to self.user_id
        let targetUserId = patientId ?? self.user_id
        print("targetUserId: \(targetUserId)")
        
        db.collection("users").document(targetUserId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                let notFoundError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found."])
                completion(.failure(notFoundError))
                return
            }
            
            // Parse the document data
            var userProfileData = [UserProfileKey: Any]()
            
            // Fetch fields with defaults
            userProfileData[.email] = document.get(UserProfileKey.email.rawValue) as? String ?? "Not Provided"
            userProfileData[.name] = document.get(UserProfileKey.name.rawValue) as? String ?? "N/A"
            userProfileData[.uid] = document.get(UserProfileKey.uid.rawValue) as? String ?? ""
            userProfileData[.userType] = document.get(UserProfileKey.userType.rawValue) as? String ?? "Unknown"
            userProfileData[.dob] = document.get(UserProfileKey.dob.rawValue) as? String ?? "N/A"
            userProfileData[.gender] = document.get(UserProfileKey.gender.rawValue) as? String ?? "Other"
            userProfileData[.bloodgroup] = document.get(UserProfileKey.bloodgroup.rawValue) as? String ?? "N/A"
            
            if let linkedHospitals = document.get(UserProfileKey.linkedHospitals.rawValue) as? [String] {
                userProfileData[.linkedHospitals] = linkedHospitals
            }
            
            if let linkedInsurers = document.get(UserProfileKey.linkedInsurers.rawValue) as? [String] {
                userProfileData[.linkedInsurers] = linkedInsurers
            }
            
            if let profilePhoto = document.get(UserProfileKey.profileImage.rawValue) as? String {
                userProfileData[.profileImage] = profilePhoto
            }
            
            print("User Profile Data: \(userProfileData)")
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
