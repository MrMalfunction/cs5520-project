//
//  PatientHSController.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/25/24.
//



import UIKit

class PatientHSController: UIViewController {
    
    // MARK: - Properties
    private let customView = PatientHSView() // Custom view for the Home Screen

    // MARK: - Lifecycle Methods
    override func loadView() {
        // Assign the custom view to the controller's view
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        
        // Set up button actions
        customView.provideAccessButton.addTarget(self, action: #selector(onProvideAccessTapped), for: .touchUpInside)
        customView.userPhotoButton.addTarget(self, action: #selector(onUserPhotoTapped), for: .touchUpInside)
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Add action to the buttons
        customView.addMedicalRecordButton.addTarget(self, action: #selector(onAddMedicalRecordTapped), for: .touchUpInside)
        customView.provideAccessButton.addTarget(self, action: #selector(onProvideAccessTapped), for: .touchUpInside)
        customView.reviewAccessButton.addTarget(self, action: #selector(onReviewAccessTapped), for: .touchUpInside)
    }

    @objc private func onAddMedicalRecordTapped() {
        // Navigate to the Add Medical Record screen
        let addMedicalRecordController = AddPatientRecordController()
        navigationController?.pushViewController(addMedicalRecordController, animated: true)
    }
    
    @objc private func onProvideAccessTapped() {
        // Handle "Provide Access" screen navigation
        // Navigate to the Provide Access screen (implement the screen as per your design)
        // Navigate to the Provide Access screen
        let provideAccessController = ProvideAccessController()
        navigationController?.pushViewController(provideAccessController, animated: true)
    }
    
    @objc private func onReviewAccessTapped() {
        let reviewAccessController = ReviewAccessController()
         navigationController?.pushViewController(reviewAccessController, animated: true)
    }
    
    @objc private func onUserPhotoTapped() {
        let userProfileController = UserProfileController()
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}
