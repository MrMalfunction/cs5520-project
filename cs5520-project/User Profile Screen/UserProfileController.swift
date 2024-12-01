//
//  UserProfileController.swift
//  cs5520-project
//
//  Created by MAD6 on 11/29/24.
//


//import UIKit
//
//class UserProfileController: UIViewController {
//    
//    // MARK: - Properties
//    private let userProfileView = UserProfileView()
//    
//    override func loadView() {
//        view = userProfileView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "User Profile"
//        loadUserData()
//        setupActions()
//    }
//    
//    private func setupActions() {
//        userProfileView.updateImageButton.addTarget(self, action: #selector(onUpdateImageTapped), for: .touchUpInside)
//        userProfileView.updateButton.addTarget(self, action: #selector(onUpdateProfileTapped), for: .touchUpInside)
//    }
//    
//    private func loadUserData() {
//        // Simulating fetching user data
//        userProfileView.userIdField.text = "12345" // User ID (disabled)
//        userProfileView.fullNameField.text = "John Doe"
//        userProfileView.emailField.text = "john.doe@example.com"
//        userProfileView.currentProviderLabel.text = "Current Provider: Blue Shield"
//        userProfileView.insuranceProviderCodeField.text = "BLS123"
//    }
//    
//    @objc private func onUpdateImageTapped() {
//        // Handle image update logic
//        print("Update Image button tapped.")
//    }
//    
//    @objc private func onUpdateProfileTapped() {
//        // Handle profile update logic
//        let updatedName = userProfileView.fullNameField.text ?? ""
//        let updatedEmail = userProfileView.emailField.text ?? ""
//        let updatedCode = userProfileView.insuranceProviderCodeField.text ?? ""
//        
//        print("Profile updated with:")
//        print("Name: \(updatedName), Email: \(updatedEmail), Insurance Code: \(updatedCode)")
//        
//        showAlert(message: "Profile updated successfully.")
//    }
//    
//    private func showAlert(message: String) {
//        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertController, animated: true)
//    }
//}


import UIKit
import PhotosUI

class UserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    // MARK: - Properties
    private let userProfileView = UserProfileView()
    
    override func loadView() {
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Profile"
        loadUserData()
        setupActions()
    }
    
    private func setupActions() {
        userProfileView.updateImageButton.addTarget(self, action: #selector(onUpdateImageTapped), for: .touchUpInside)
        userProfileView.updateButton.addTarget(self, action: #selector(onUpdateProfileTapped), for: .touchUpInside)
    }
    
//    private func loadUserData() {
//        // Simulating fetching user data
//        userProfileView.userIdField.text = "User Id" // User ID (disabled)
//        userProfileView.fullNameField.text = "Full Name"
//        userProfileView.emailField.text = "Email Id"
//        userProfileView.currentProviderLabel.text = "Current Provider: Blue Shield"
//        userProfileView.insuranceProviderCodeField.text = "Insurance Provider Code"
//        userProfileView.profileImageView.image = UIImage(systemName: "person.circle.fill")
//    }
    
    private func loadUserData() {
        AuthHelper().fetchUserData { [weak self] result in
            switch result {
            case .success(let userData):
                DispatchQueue.main.async {
                    self?.userProfileView.userIdField.text = userData["uid"] as? String
                    self?.userProfileView.fullNameField.text = userData["name"] as? String
                    self?.userProfileView.emailField.text = userData["email"] as? String
                    self?.userProfileView.currentProviderLabel.text = "Current Provider: \(userData["userType"] as? String ?? "N/A")"
                    // Optionally load the profile image
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: "Failed to load user data: \(error.localizedDescription)")
                }
            }
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
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { image, _ in
            DispatchQueue.main.async {
                self.userProfileView.profileImageView.image = image as? UIImage
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            userProfileView.profileImageView.image = image
        }
    }
    
//    @objc private func onUpdateProfileTapped() {
//        let updatedName = userProfileView.fullNameField.text ?? ""
//        let updatedEmail = userProfileView.emailField.text ?? ""
//        let updatedCode = userProfileView.insuranceProviderCodeField.text ?? ""
//        
//        print("Profile updated with:")
//        print("Name: \(updatedName), Email: \(updatedEmail), Insurance Code: \(updatedCode)")
//        
//        showAlert(message: "Profile updated successfully.")
//    }
    
    @objc private func onUpdateProfileTapped() {
        let updatedData: [String: Any] = [
            "name": userProfileView.fullNameField.text ?? "",
            "email": userProfileView.emailField.text ?? "",
            "userType": userProfileView.currentProviderLabel.text?.replacingOccurrences(of: "Current Provider: ", with: "") ?? "",
        ]
        
        AuthHelper().updateUserData(data: updatedData) { [weak self] result in
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
