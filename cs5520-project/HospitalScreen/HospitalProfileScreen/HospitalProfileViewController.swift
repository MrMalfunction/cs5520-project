//
//  HospitalProfileViewController.swift
//  cs5520-project
//
//  Created by Sumit Pagar on 12/2/24.
//

import UIKit
import PhotosUI
import Firebase

class HospitalProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    // MARK: - Properties
    private let hospitalProfileView = HospitalProfileView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let authHelper = AuthHelper()
    private let firestoreHelper = FirestoreGenericHelpers()

    override func loadView() {
        view = hospitalProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hospital Profile"
        loadHospitalData()
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
        hospitalProfileView.updateImageButton.addTarget(self, action: #selector(onUpdateImageTapped), for: .touchUpInside)
        hospitalProfileView.updateButton.addTarget(self, action: #selector(onUpdateProfileTapped), for: .touchUpInside)
    }

//    // MARK: - Load Hospital Data
//    private func loadHospitalData2() {
//        // Retrieve data from UserDefaults
//        let userId = UserDefaults.standard.string(forKey: "uid") ?? "N/A"
//        let username = UserDefaults.standard.string(forKey: "username") ?? "N/A"
//        let email = UserDefaults.standard.string(forKey: "email") ?? "N/A"
//
//        // Populate the fields
//        hospitalProfileView.userIdField.text = userId
//        hospitalProfileView.hospitalNameField.text = username
//        hospitalProfileView.emailField.text = email
//
//        // Leave address and contact info fields empty
//        hospitalProfileView.addressField.text = ""
//        hospitalProfileView.contactInfoField.text = ""
//        
//        // Decode and display the profile image if available
//        let userData = UserDefaults.standard.dictionary(forKey: userId) ?? [:]
//        if let profileImageBase64 = userData[.profileImage] as? String {
//            self?.decodeBase64ToImage(base64String: profileImageBase64)
//        }
//    }
    
    private func loadHospitalData2() {
        self.authHelper.fetchUserData { [weak self] result in
            switch result {
            case .success(let userData):
                // Safely unwrap and set the values from the userData dictionary
                if let userId = userData[.uid] as? String {
                    self?.hospitalProfileView.userIdField.text = userId
                }
                if let fullName = userData[.name] as? String {
                    self?.hospitalProfileView.hospitalNameField.text = fullName
                }
                if let email = userData[.email] as? String {
                    self?.hospitalProfileView.emailField.text = email
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
    
    private func loadHospitalData() {
        firestoreHelper.fetchDetailsAdd_Contact { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let hospitalData):
                    // Safely unwrap and set the values from the Firestore document
                    if let userId = hospitalData["uid"] as? String {
                        self?.hospitalProfileView.userIdField.text = userId
                    }
                    if let hospitalName = hospitalData["hospitalName"] as? String {
                        self?.hospitalProfileView.hospitalNameField.text = hospitalName
                    }
                    if let email = hospitalData["email"] as? String {
                        self?.hospitalProfileView.emailField.text = email
                    }
                    if let address = hospitalData["address"] as? String {
                        self?.hospitalProfileView.addressField.text = address
                    }
                    if let contactInfo = hospitalData["contactInfo"] as? String {
                        self?.hospitalProfileView.contactInfoField.text = contactInfo
                    }

                    // Decode and display the profile image if available
                    if let profileImageBase64 = hospitalData["profileImage"] as? String {
                        self?.decodeBase64ToImage(base64String: profileImageBase64)
                    }

                case .failure(let error):
                    self?.showAlert(message: "Failed to load hospital data: \(error.localizedDescription)")
                }
            }
        }
    }

    
    private func decodeBase64ToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
           let image = UIImage(data: imageData) {
            hospitalProfileView.profileImageView.image = image
        }
    }

    // MARK: - Update Profile Action
    @objc private func onUpdateProfileTapped() {
        // Show loading indicator
        //activityIndicator.startAnimating()
        let contactInfo = hospitalProfileView.contactInfoField.text ?? ""
        
        // Validate contact info
        guard isValidPhoneNumber(contactInfo) else {
            showAlert(message: "Invalid contact number. Please enter a valid phone number.")
            return
        }

        // Data to update
        let updatedData: [String: Any] = [
            "hospitalName": hospitalProfileView.hospitalNameField.text ?? "",
            "address": hospitalProfileView.addressField.text ?? "",
            "contactInfo": hospitalProfileView.contactInfoField.text ?? ""
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
            self.firestoreHelper.saveProfileImageToFirestore(image: image) { error in
                // Hide the loading indicator
                self.activityIndicator.stopAnimating()
                
                if let error = error {
                    // Show an alert for failure using the provided showAlert function
                    self.showAlert(message: "Failed to upload the profile image: \(error.localizedDescription)")
                } else {
                    // Show an alert for success and update the profile image
                    self.showAlert(message: "Profile image uploaded successfully.") {
                        self.hospitalProfileView.profileImageView.image = image
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
                                self.hospitalProfileView.profileImageView.image = selectedImage
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
            //self?.navigationController?.popViewController(animated: true) // Pops the current view controller
        })
        present(alertController, animated: true, completion: nil)
    }
}
