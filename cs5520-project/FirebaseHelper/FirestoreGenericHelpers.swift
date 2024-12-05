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
            // If image conversion fails, proceed without raising an error
            print("Failed to convert image to JPEG data.")
            return
        }
        
        // Convert the image data to a Base64 string
        let base64String = imageData.base64EncodedString()
        
        // Upload the Base64 string to Firestore
        let userRef = db.collection("users").document(self.user_id)
        
        userRef.updateData([
            "profileImage": base64String
        ]) { error in
            if let error = error {
                // Pass the error back in the completion
                completion(error)
            } else {
                // Indicate success (nil error)
                completion(nil)
            }
        }
    }
    
    func fetchBusinessIDsForInsuranceCompanies(completion: @escaping (Result<[String], Error>) -> Void) {
        // Query the `users_db` collection where `userType` is "Insurance Company"
        users_db
            .whereField("userType", isEqualTo: "Insurance Company")
            .getDocuments { (querySnapshot, error) in
                
                // Handle errors
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Ensure snapshot is not nil
                guard let snapshot = querySnapshot else {
                    completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
                    return
                }
                
                // Extract businessID from documents
                var businessIDs: [String] = []
                for document in snapshot.documents {
                    if let businessID = document.data()["businessID"] as? String {
                        businessIDs.append(businessID)
                    }
                }
                
                // Check if the array is empty
                if businessIDs.isEmpty {
                    // Provide a sample list if no data is found
                    let sampleBusinessIDs = ["sampleID1", "sampleID2", "sampleID3"]
                    completion(.success(sampleBusinessIDs))
                } else {
                    // Return the retrieved list if not empty
                    completion(.success(businessIDs))
                }
            }
    }
    
}
