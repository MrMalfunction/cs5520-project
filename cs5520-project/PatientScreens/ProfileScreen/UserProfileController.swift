import UIKit
import PhotosUI
import Firebase

class UserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties
    private let userProfileView = UserProfileView()
    private let authHelper = AuthHelper()
    private let firestoreHelper = FirestoreGenericHelpers()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var businessIDs: [String] = [] // Store fetched business IDs

    
    override func loadView() {
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Patient Profile"
        loadUserData()
        setupActions()
        setupActivityIndicator()
        configurePickerView()
        setupPickerWithToolbar()
        fetchBusinessIDsAndPopulatePicker() // Fetch and populate picker data
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
    
    private func configurePickerView() {
        userProfileView.insuranceProviderPicker.delegate = self
        userProfileView.insuranceProviderPicker.dataSource = self
    }
    

    
    private func fetchBusinessIDsAndPopulatePicker() {
        firestoreHelper.fetchBusinessIDsForInsuranceCompanies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ids):
                    self?.businessIDs = ids
                    self?.userProfileView.insuranceProviderPicker.reloadAllComponents()
//                    if let firstProvider = self?.businessIDs.first {
//                        self?.userProfileView.currentProviderLabel.text = "Selected Provider: \(firstProvider)"
//                    }
                case .failure(let error):
                    self?.showAlert(message: "Failed to fetch business IDs: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupPickerWithToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // Create a Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([flexibleSpace, doneButton], animated: false)

        // Set the toolbar as the accessory view for the text field
        userProfileView.insuranceProviderCodeField.inputAccessoryView = toolbar
        userProfileView.insuranceProviderCodeField.inputView = userProfileView.insuranceProviderPicker
    }

    @objc private func donePicker() {
        let selectedRow = userProfileView.insuranceProviderPicker.selectedRow(inComponent: 0)
        if businessIDs.indices.contains(selectedRow) {
            let selectedProvider = businessIDs[selectedRow]
            userProfileView.insuranceProviderCodeField.text = selectedProvider
        }
        // Dismiss the picker
        userProfileView.insuranceProviderCodeField.resignFirstResponder()
    }

    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return businessIDs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return businessIDs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the label or selected provider field
//        userProfileView.currentProviderLabel.text = "Selected Provider: \(businessIDs[row])"
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
        var updatedData: [String: Any]
        if userProfileView.insuranceProviderCodeField.text?.isEmpty == false {
            updatedData = [
                "name": userProfileView.fullNameField.text ?? "",
            "linkedInsurers": userProfileView.insuranceProviderCodeField.text?.isEmpty == false ?
            [userProfileView.insuranceProviderCodeField.text!] : []]
            
        } else {
            updatedData = [
                "name": userProfileView.fullNameField.text ?? ""]
        }
        
        self.authHelper.updateUserData(data: updatedData) { [self] result in
            switch result {
            case .success:
                // After successfully updating user data, call updateUserInInsurer
                guard
                    let newInsurerName = self.userProfileView.insuranceProviderCodeField.text, !newInsurerName.isEmpty,
                    let currentInsurerName = self.userProfileView.currentProviderLabel.text?.replacingOccurrences(of: "Current Provider: ", with: "")
                else {
                    self.showAlert(message: "Profile updated, but insufficient insurer details provided.")
                    return
                }
                print(currentInsurerName)

                // Call updateUserInInsurer with both current and new insurer names
                self.firestoreHelper.updateUserInInsurer(currentInsName: currentInsurerName, newInsName: newInsurerName) { insurerResult in
                    switch insurerResult {
                    case .success:
                        self.showAlert(message: "Profile and insurer updated successfully.")
                        if self.userProfileView.insuranceProviderCodeField.text?.isEmpty == false {
                            self.userProfileView.currentProviderLabel.text = "Current Provider: " + self.userProfileView.insuranceProviderCodeField.text!
                        }
                    case .failure(let error):
                        self.showAlert(message: "Profile updated, but failed to update insurer: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                self.showAlert(message: "Failed to update profile: \(error.localizedDescription)")
            }
        }
        
    }
}


