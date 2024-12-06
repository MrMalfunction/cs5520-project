//
//  PatientHSController.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/25/24.
//

import UIKit

class PatientHSController: UIViewController {
    
    private let customView = PatientHSView() // Custom view for the Home Screen
    private let authHelper = AuthHelper()

    override func loadView() {
        // Assign the custom view to the controller's view
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        self.navigationItem.hidesBackButton = true
        setupNavigationBar()
        // Set up button actions
        customView.provideAccessButton.addTarget(self, action: #selector(onProvideAccessTapped), for: .touchUpInside)
//        customView.userPhotoButton.addTarget(self, action: #selector(onUserPhotoTapped), for: .touchUpInside)
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Add action to the buttons
        customView.addMedicalRecordButton.addTarget(self, action: #selector(onAddMedicalRecordTapped), for: .touchUpInside)
        customView.viewMedicalRecordButton.addTarget(self, action: #selector(onViewMedicalRecordTapped), for: .touchUpInside)
        customView.provideAccessButton.addTarget(self, action: #selector(onProvideAccessTapped), for: .touchUpInside)
        customView.reviewAccessButton.addTarget(self, action: #selector(onReviewAccessTapped), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        // Create profile button
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"),
                                            style: .plain, target: self, action: #selector(profileButtonTapped))
        profileButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = profileButton
        
        // Create logout button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        logoutButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func onAddMedicalRecordTapped() {
        // Navigate to the Add Medical Record screen
        let addMedicalRecordController = AddMedicalRecordScreenController()
        navigationController?.pushViewController(addMedicalRecordController, animated: true)
    }
    
    @objc private func onViewMedicalRecordTapped() {
        // Navigate to the View Medical Record screen
        let viewMedicalRecordController = ViewMedicalRecordsController()
        navigationController?.pushViewController(viewMedicalRecordController, animated: true)
    }
    
    @objc private func onProvideAccessTapped() {
        // Handle "Provide Access" screen navigation
        let provideAccessController = ProvideHospitalAccessController()
        navigationController?.pushViewController(provideAccessController, animated: true)
    }
    
    @objc private func onReviewAccessTapped() {
        let reviewAccessController = ReviewHospitalAccessController()
        navigationController?.pushViewController(reviewAccessController, animated: true)
    }
    
    @objc private func onUserPhotoTapped() {
        let userProfileController = UserProfileController()
        navigationController?.pushViewController(userProfileController, animated: true)
    }

    @objc private func profileButtonTapped() {
        // Handle profile button tap (navigate to profile view or handle functionality)
        print("Profile button tapped")
        let userProfileController = UserProfileController()
        self.navigationController?.pushViewController(userProfileController, animated: true)
    }

    @objc private func logoutButtonTapped() {
        // Handle logout button tap (perform logout or show confirmation)
        print("Logout button tapped")
        // Perform logout functionality (e.g., navigate to login screen, clear session, etc.)
        self.authHelper.logout_user(){
            result in
            switch result{
            case .success:
                    print("Logout Success")
            case .failure:
                print("Logout Failure")
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}
