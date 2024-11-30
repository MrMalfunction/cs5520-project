//
//  ProvideAccessController.swift
//  cs5520-project
//
//  Created by MAD6 on 11/26/24.
//


//import UIKit
//
//class ProvideAccessController: UIViewController {
//    
//    // MARK: - Properties
//    private let provideAccessView = ProvideAccessView()
//    
//    override func loadView() {
//        view = provideAccessView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set up the button action
//        provideAccessView.approveButton.addTarget(self, action: #selector(onApproveButtonTapped), for: .touchUpInside)
//    }
//    
//    @objc private func onApproveButtonTapped() {
//        let hospitalCode = provideAccessView.hospitalCodeField.text ?? ""
//        
//        // You can add logic here to handle the hospital code
//        if hospitalCode.isEmpty {
//            showAlert(message: "Please enter the hospital code.")
//        } else {
//            // Logic for approving access (e.g., saving the hospital code or checking validity)
//            showAlert(message: "Access approved.")
//        }
//    }
//    
//    private func showAlert(message: String) {
//        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alertController, animated: true, completion: nil)
//    }
//}


import UIKit

class ProvideAccessController: UIViewController {
    
    // MARK: - Properties
    private let provideAccessView = ProvideAccessView()
    private let authHelper = AuthHelper()
    
    override func loadView() {
        view = provideAccessView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Provide Access"
        
        // Set up the button action
        provideAccessView.approveButton.addTarget(self, action: #selector(onApproveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func onApproveButtonTapped() {
        let hospitalCode = provideAccessView.hospitalCodeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if hospitalCode.isEmpty {
            showAlert(message: "Please enter the hospital code.")
            return
        }
        
        // Grant access to hospital
        authHelper.grantAccessToHospital(hospitalCode: hospitalCode, requestType: "viewOrEdit") { [weak self] result in
            switch result {
            case .success:
                self?.showAlert(message: "Access successfully granted to hospital with code \(hospitalCode).")
            case .failure(let error):
                self?.showAlert(message: "Failed to grant access: \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}

