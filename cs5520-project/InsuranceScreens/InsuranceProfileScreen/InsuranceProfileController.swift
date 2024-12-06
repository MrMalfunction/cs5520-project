import UIKit
import PhotosUI
import Firebase

class InsuranceProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    // MARK: - Properties
    private let insuranceProfileView = InsuranceProfileView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let authHelper = AuthHelper()
    private let firestoreHelper = FirestoreGenericHelpers()

    override func loadView() {
        view = insuranceProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Insurance Profile"
        loadInsuranceData()
        setupActions()
        setupActivityIndicator()
    }

    // MARK: - Setup Activity Indicator
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Setup Actions
    private func setupActions() {
        insuranceProfileView.updateImageButton.addTarget(self, action: #selector(onUpdateImageTapped), for: .touchUpInside)
        insuranceProfileView.updateButton.addTarget(self, action: #selector(onUpdateProfileTapped), for: .touchUpInside)
    }

    // MARK: - Load Insurance Data
    private func loadInsuranceData() {
        firestoreHelper.fetchDetailsAdd_Contact { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let insuranceData):
                    // Safely unwrap and set the values from the Firestore document
                    if let userId = insuranceData["uid"] as? String {
                        self?.insuranceProfileView.userIdField.text = userId
                    }
                    if let insuranceCompanyName = insuranceData["name"] as? String {
                        self?.insuranceProfileView.insuranceCompanyNameField.text = insuranceCompanyName
                    }
                    if let email = insuranceData["email"] as? String {
                        self?.insuranceProfileView.emailField.text = email
                    }
                    if let address = insuranceData["address"] as? String {
                        self?.insuranceProfileView.addressField.text = address
                    }
                    if let contactInfo = insuranceData["contactInfo"] as? String {
                        self?.insuranceProfileView.contactInfoField.text = contactInfo
                    }

                    // Decode and display the profile image if available
                    if let profileImageBase64 = insuranceData["profileImage"] as? String {
                        self?.decodeBase64ToImage(base64String: profileImageBase64)
                    }

                case .failure(let error):
                    self?.showAlert(message: "Failed to load insurance data: \(error.localizedDescription)")
                }
            }
        }
    }

    private func decodeBase64ToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
           let image = UIImage(data: imageData) {
            insuranceProfileView.profileImageView.image = image
        }
    }

    // MARK: - Update Profile Action
    @objc private func onUpdateProfileTapped() {
        
        let contactInfo = insuranceProfileView.contactInfoField.text ?? ""
        
        // Validate contact info
        guard isValidPhoneNumber(contactInfo) else {
            showAlert(message: "Invalid contact number. Please enter a valid phone number.")
            return
        }
        // Show loading indicator
        //activityIndicator.startAnimating()

        // Data to update
        let updatedData: [String: Any] = [
            "insuranceCompanyName": insuranceProfileView.insuranceCompanyNameField.text ?? "",
            "address": insuranceProfileView.addressField.text ?? "",
            "contactInfo": insuranceProfileView.contactInfoField.text ?? ""
        ]

        self.authHelper.updateUserData(data: updatedData) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success:
                    self?.showAlert(message: "Profile updated successfully.")
                case .failure(let error):
                    self?.showAlert(message: "Failed to update profile: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Update Image Action
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
            firestoreHelper.saveProfileImageToFirestore(image: image) { error in
                // Hide the loading indicator
                self.activityIndicator.stopAnimating()

                if let error = error {
                    self.showAlert(message: "Failed to upload the profile image: \(error.localizedDescription)")
                } else {
                    self.showAlert(message: "Profile image uploaded successfully.") {
                        self.insuranceProfileView.profileImageView.image = image
                    }
                }
            }
        }
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            showAlert(message: "No valid image selected.")
            self.activityIndicator.stopAnimating()
            return
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to load image: \(error.localizedDescription)")
                    self.activityIndicator.stopAnimating()
                }
                return
            }

            if let selectedImage = image as? UIImage {
                firestoreHelper.saveProfileImageToFirestore(image: selectedImage) { uploadError in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        if let uploadError = uploadError {
                            self.showAlert(message: "Failed to upload the profile image: \(uploadError.localizedDescription)")
                        } else {
                            self.showAlert(message: "Profile image uploaded successfully.") {
                                self.insuranceProfileView.profileImageView.image = selectedImage
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to process the selected image.")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }


    // MARK: - Show Alert
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            completion?()
            //self?.navigationController?.popViewController(animated: true)
        })
        present(alertController, animated: true, completion: nil)
    }
}

