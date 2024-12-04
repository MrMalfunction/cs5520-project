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
    
}
