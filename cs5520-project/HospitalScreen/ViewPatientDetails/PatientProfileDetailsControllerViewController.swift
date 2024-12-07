//
//  PatientProfileDetailsControllerViewController.swift
//  cs5520-project
//
//  Created by Sumit Pagar on 12/7/24.
//

import UIKit

class PatientProfileDetailsController: UIViewController {
    
    let profileView = PatientProfileDetailsView()
    private let authHelper = AuthHelper()
    var patientId: String!
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile(patientId: patientId)
    }
    
    private func fetchUserProfile(patientId: String) {
        print("patientId: \(patientId)")
        authHelper.fetchUserData(patientId: patientId) { [weak self] result in
            switch result {
            case .success(let userData):
                self?.populateFields(userData: userData)
                
                if let profileImageBase64 = userData[.profileImage] as? String {
                    self?.decodeBase64ToImage(base64String: profileImageBase64)
                }
                
            case .failure(let error):
                self?.showAlert(message: "Failed to load user data: \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func populateFields(userData: [UserProfileKey: Any]) {
        profileView.nameField.text = userData[.name] as? String
        profileView.emailField.text = userData[.email] as? String
        profileView.dobField.text = userData[.dob] as? String
        profileView.bloodGroupField.text = userData[.bloodgroup] as? String
        profileView.genderField.text = userData[.gender] as? String
        profileView.userIdField.text = userData[.uid] as? String
        profileView.userTypeField.text = userData[.userType] as? String
        profileView.linkedHospitalsField.text = (userData[.linkedHospitals] as? [String])?.joined(separator: ", ") ?? "None"
        profileView.linkedInsurersField.text = (userData[.linkedInsurers] as? [String])?.joined(separator: ", ") ?? "None"
    }
    
    private func decodeBase64ToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            profileView.profileImageView.image = UIImage(data: imageData)
        }
    }
}
