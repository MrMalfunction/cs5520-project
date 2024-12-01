//
//  AddMedicalRecordController.swift
//  cs5520-project
//
//  Created by MAD6 on 11/25/24.
//

import UIKit
import FirebaseFirestore

class AddPatientRecordController: UIViewController {
    private let addMedicalRecordView = AddPatientRecordView()
    private let authHelper = AuthHelper() // Instance of AuthHelper
    
    override func loadView() {
        view = addMedicalRecordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medical Record"
        setupActions()
    }
    
    private func setupActions() {
        addMedicalRecordView.saveButton.addTarget(self, action: #selector(saveRecord), for: .touchUpInside)
    }
    
//    @objc private func saveRecord() {
//        // Validate required fields
//        guard validateFields() else { return }
//        
//        // Gather data from the form
//        let patientData: [String: Any] = [
//            "firstName": addMedicalRecordView.firstNameField.text ?? "",
//            "lastName": addMedicalRecordView.lastNameField.text ?? "",
//            "preferredName": addMedicalRecordView.preferredNameField.text ?? "",
//            "patientIdentifier": addMedicalRecordView.patientIdentifierField.text ?? "",
//            "gender": addMedicalRecordView.genderField.text ?? "",
//            "preferredPronouns": addMedicalRecordView.preferredPronounsField.text ?? "",
//            "dob": addMedicalRecordView.dobField.text ?? "",
//            "maritalStatus": addMedicalRecordView.maritalStatusField.text ?? "",
//            "address": addMedicalRecordView.addressField.text ?? "",
//            "city": addMedicalRecordView.cityField.text ?? "",
//            "state": addMedicalRecordView.stateField.text ?? "",
//            "zipCode": addMedicalRecordView.zipCodeField.text ?? "",
//            "email": addMedicalRecordView.emailField.text ?? "",
//            "phoneNumber": addMedicalRecordView.phoneNumberField.text ?? "",
//            "emergencyContact1": [
//                "name": addMedicalRecordView.emergencyContact1NameField.text ?? "",
//                "relation": addMedicalRecordView.emergencyContact1RelationField.text ?? "",
//                "number": addMedicalRecordView.emergencyContact1NumberField.text ?? ""
//            ],
//            "emergencyContact2": [
//                "name": addMedicalRecordView.emergencyContact2NameField.text ?? "",
//                "relation": addMedicalRecordView.emergencyContact2RelationField.text ?? "",
//                "number": addMedicalRecordView.emergencyContact2NumberField.text ?? ""
//            ],
//            "primaryCarePhysician": addMedicalRecordView.primaryCarePhysicianField.text ?? "",
//            "physicianAddress": addMedicalRecordView.physicianAddressField.text ?? "",
//            "physicianContact": addMedicalRecordView.physicianContactField.text ?? "",
//            "medicalConditions": addMedicalRecordView.medicalConditionsField.text ?? "",
//            "medications": addMedicalRecordView.medicationsField.text ?? "",
//            "insurance": [
//                "carrier": addMedicalRecordView.insuranceCarrierField.text ?? "",
//                "plan": addMedicalRecordView.insurancePlanField.text ?? "",
//                "policyNumber": addMedicalRecordView.policyNumberField.text ?? "",
//                "groupNumber": addMedicalRecordView.groupNumberField.text ?? "",
//                "ssn": addMedicalRecordView.ssnField.text ?? ""
//            ],
//            "employmentStatus": addMedicalRecordView.employmentStatusField.text ?? "",
//            "occupation": addMedicalRecordView.occupationField.text ?? "",
//            "industry": addMedicalRecordView.industryField.text ?? "",
//            "companyName": addMedicalRecordView.companyNameField.text ?? "",
//            "companyAddress": addMedicalRecordView.companyAddressField.text ?? "",
//            "companyCity": addMedicalRecordView.companyCityField.text ?? "",
//            "companyState": addMedicalRecordView.companyStateField.text ?? "",
//            "companyZipCode": addMedicalRecordView.companyZipCodeField.text ?? "",
//            "timestamp": FieldValue.serverTimestamp()
//        ]
//        
//        // Show loading indicator
//        let loadingAlert = showLoadingIndicator(message: "Saving...")
//        
//        // Save the record using AuthHelper
//        authHelper.savePatientData(patientData: patientData) { result in
//            // Dismiss loading indicator
//            loadingAlert.dismiss(animated: true) {
//                switch result {
//                case .success:
//                    self.showAlert(title: "Success", message: "Medical record successfully saved.") {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                case .failure(let error):
//                    self.showAlert(title: "Error", message: "Failed to save the medical record: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
    @objc private func saveRecord() {
        // Validate required fields
        guard validateFields() else { return }
        
        // Retrieve and sanitize field values
        let medicalConditions = addMedicalRecordView.medicalConditionsField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let medications = addMedicalRecordView.medicationsField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        let patientData: [String: Any] = [
            "firstName": addMedicalRecordView.firstNameField.text ?? "",
            "lastName": addMedicalRecordView.lastNameField.text ?? "",
            "preferredName": addMedicalRecordView.preferredNameField.text ?? "",
            "patientIdentifier": addMedicalRecordView.patientIdentifierField.text ?? "",
            "gender": addMedicalRecordView.genderField.text ?? "",
            "preferredPronouns": addMedicalRecordView.preferredPronounsField.text ?? "Not Provided",
            "dob": addMedicalRecordView.dobField.text ?? "",
            "maritalStatus": addMedicalRecordView.maritalStatusField.text ?? "Not Provided",
            "address": addMedicalRecordView.addressField.text ?? "Not Provided",
            "city": addMedicalRecordView.cityField.text ?? "",
            "state": addMedicalRecordView.stateField.text ?? "Not Provided",
            "zipCode": addMedicalRecordView.zipCodeField.text ?? "Not Provided",
            "email": addMedicalRecordView.emailField.text ?? "Not Provided",
            "phoneNumber": addMedicalRecordView.phoneNumberField.text ?? "Not Provided",
            "emergencyContact1": [
                "name": addMedicalRecordView.emergencyContact1NameField.text ?? "",
                "relation": addMedicalRecordView.emergencyContact1RelationField.text ?? "",
                "number": addMedicalRecordView.emergencyContact1NumberField.text ?? ""
            ],
            "emergencyContact2": [
                "name": addMedicalRecordView.emergencyContact2NameField.text ?? "Not Provided",
                "relation": addMedicalRecordView.emergencyContact2RelationField.text ?? "Not Provided",
                "number": addMedicalRecordView.emergencyContact2NumberField.text ?? "Not Provided"
            ],
            "primaryCarePhysician": addMedicalRecordView.primaryCarePhysicianField.text ?? "Not Provided",
            "physicianAddress": addMedicalRecordView.physicianAddressField.text ?? "Not Provided",
            "physicianContact": addMedicalRecordView.physicianContactField.text ?? "Not Provided",
            "medicalConditions": medicalConditions.isEmpty || medicalConditions == "List any medical conditions" ? "None" : medicalConditions,
            "medications": medications.isEmpty || medications == "List any current medications" ? "None" : medications,
            "insurance": [
                "carrier": addMedicalRecordView.insuranceCarrierField.text ?? "",
                "plan": addMedicalRecordView.insurancePlanField.text ?? "",
                "policyNumber": addMedicalRecordView.policyNumberField.text ?? "",
                "groupNumber": addMedicalRecordView.groupNumberField.text ?? "",
                "ssn": addMedicalRecordView.ssnField.text ?? ""
            ],
            "employmentStatus": addMedicalRecordView.employmentStatusField.text ?? "",
            "occupation": addMedicalRecordView.occupationField.text ?? "Not Provided",
            "industry": addMedicalRecordView.industryField.text ?? "Not Provided",
            "companyName": addMedicalRecordView.companyNameField.text ?? "Not Provided",
            "companyAddress": addMedicalRecordView.companyAddressField.text ?? "Not Provided",
            "companyCity": addMedicalRecordView.companyCityField.text ?? "Not Provided",
            "companyState": addMedicalRecordView.companyStateField.text ?? "Not Provided",
            "companyZipCode": addMedicalRecordView.companyZipCodeField.text ?? "Not Provided",
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Debugging logs
        print("Patient Data:", patientData)
        
        // Show loading indicator
        let loadingAlert = showLoadingIndicator(message: "Saving...")
        
        // Save the record using AuthHelper
        authHelper.savePatientData(patientData: patientData) { result in
            // Dismiss loading indicator
            loadingAlert.dismiss(animated: true) {
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Medical record successfully saved.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed to save the medical record: \(error.localizedDescription)")
                }
            }
        }
    }

    
    // MARK: - Validation
    private func validateFields() -> Bool {
        guard !(addMedicalRecordView.firstNameField.text?.isEmpty ?? true) else {
            showAlert(title: "Validation Error", message: "First Name is required.")
            return false
        }
        guard !(addMedicalRecordView.lastNameField.text?.isEmpty ?? true) else {
            showAlert(title: "Validation Error", message: "Last Name is required.")
            return false
        }
        guard !(addMedicalRecordView.dobField.text?.isEmpty ?? true) else {
            showAlert(title: "Validation Error", message: "Date of Birth is required.")
            return false
        }
        guard !(addMedicalRecordView.genderField.text?.isEmpty ?? true) else {
            showAlert(title: "Validation Error", message: "Gender is required.")
            return false
        }
        return true
    }
    
    // MARK: - Alert
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion?() }))
        present(alert, animated: true)
    }
    
    // MARK: - Loading Indicator
    private func showLoadingIndicator(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: 30)
        ])
        
        present(alert, animated: true)
        return alert
    }
}
