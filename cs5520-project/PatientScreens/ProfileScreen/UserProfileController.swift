import UIKit
import PhotosUI
import Firebase

class UserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    // MARK: - Properties
    private let userProfileView = UserProfileView()
    private let authHelper = AuthHelper()
    private let firestoreHelper = FirestoreGenericHelpers()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Patient Profile"
        loadUserData()
        setupActions()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        // Set up the activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)
        
        // Center the activity indicator on the screen
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        userProfileView.updateImageButton.addTarget(self, action: #selector(onUpdateImageTapped), for: .touchUpInside)
        userProfileView.updateButton.addTarget(self, action: #selector(onUpdateProfileTapped), for: .touchUpInside)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true, completion: nil)
    }

    private func loadUserData() {
        self.authHelper.fetchUserData { [weak self] result in
            switch result {
            case .success(let userData):
                // Safely unwrap and set the values from the userData dictionary
                if let userId = userData[.uid] as? String {
                    self?.userProfileView.userIdField.text = userId
                }
                if let fullName = userData[.name] as? String {
                    self?.userProfileView.fullNameField.text = fullName
                }
                if let email = userData[.email] as? String {
                    self?.userProfileView.emailField.text = email
                }
                if let insuranceProviders = userData[.linkedInsurers] as? [String], !insuranceProviders.isEmpty {
                    self?.userProfileView.currentProviderLabel.text = "Current Provider: \(insuranceProviders[0])"
                } else {
                    self?.userProfileView.currentProviderLabel.text = "Current Provider: N/A"
                }
                
                // Decode and display the profile image if available
                if let profileImageBase64 = userData[.profileImage] as? String {
                    self?.decodeBase64ToImage(base64String: profileImageBase64)
                }
                
            case .failure(let error):
                self?.showAlert(message: "Failed to load user data: \(error.localizedDescription)")
            }
        }
    }

    private func decodeBase64ToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
           let image = UIImage(data: imageData) {
            print("Decoding Image")
            userProfileView.profileImageView.image = image
        }
    }
    @objc private func onUpdateImageTapped() {
        let alert = UIAlertController(title: "Select Photo Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.presentGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }

    private func presentGallery() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        // Show the loading indicator
        activityIndicator.startAnimating()
        
        if let image = info[.originalImage] as? UIImage {
            // Save the selected image to Firestore
            self.firestoreHelper.saveProfileImageToFirestore(image: image) { error in
                // Hide the loading indicator
                self.activityIndicator.stopAnimating()
                
                if let error = error {
                    // Show an alert for failure using the provided showAlert function
                    self.showAlert(message: "Failed to upload the profile image: \(error.localizedDescription)")
                } else {
                    // Show an alert for success and update the profile image
                    self.showAlert(message: "Profile image uploaded successfully.") {
                        self.userProfileView.profileImageView.image = image
                    }
                }
            }
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // Show the loading indicator
        activityIndicator.startAnimating()
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            self.showAlert(message: "No valid image selected.")
            self.activityIndicator.stopAnimating() // Hide loading indicator
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to load image: \(error.localizedDescription)")
                    self.activityIndicator.stopAnimating() // Hide loading indicator
                }
                return
            }
            
            if let selectedImage = image as? UIImage {
                // Save the selected image to Firestore
                self.firestoreHelper.saveProfileImageToFirestore(image: selectedImage) { uploadError in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating() // Hide loading indicator
                        if let uploadError = uploadError {
                            self.showAlert(message: "Failed to upload the profile image: \(uploadError.localizedDescription)")
                        } else {
                            self.showAlert(message: "Profile image uploaded successfully.") {
                                self.userProfileView.profileImageView.image = selectedImage
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to process the selected image.")
                    self.activityIndicator.stopAnimating() // Hide loading indicator
                }
            }
        }
    }
    
    @objc private func onUpdateProfileTapped() {
        let updatedData: [String: Any] = [
            "name": userProfileView.fullNameField.text ?? "",
            "email": userProfileView.emailField.text ?? "",
            "userType": userProfileView.currentProviderLabel.text?.replacingOccurrences(of: "Current Provider: ", with: "") ?? "",
        ]
        
        self.authHelper.updateUserData(data: updatedData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showAlert(message: "Profile updated successfully.")
                case .failure(let error):
                    self?.showAlert(message: "Failed to update profile: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
