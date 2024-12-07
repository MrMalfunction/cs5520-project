
import UIKit
import CoreLocation
import MapKit

class PatientHSController: UIViewController {
    
    private let customView = PatientHSView() // Custom view for the Home Screen
    private let authHelper = AuthHelper()
    private let firestoreHelpers = FirestoreGenericHelpers()
    override func loadView() {
        // Assign the custom view to the controller's view
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        self.navigationItem.hidesBackButton = true
        setupNavigationBar()
        loadHospitalsOnMap()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        // Set up button actions
        customView.provideAccessButton.addTarget(self, action: #selector(onProvideAccessTapped), for: .touchUpInside)
//        customView.userPhotoButton.addTarget(self, action: #selector(onUserPhotoTapped), for: .touchUpInside)
    }
    
    func loadHospitalsOnMap() {
        firestoreHelpers.fetchHospitalsWithAddresses { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let hospitals):
                // Clear existing annotations
                customView.mapView.removeAnnotations(customView.mapView.annotations)
                
                if hospitals.isEmpty {
                    print("No hospitals with addresses found.")
                    return
                }
                print ("Found \(hospitals) hospitals with addresses.")
                // Add hospitals to the map
                for (hospitalName, address) in hospitals {
                    self.addAnnotationForAddress(address: address, title: hospitalName)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let bostonCoordinates = CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589)
                    let region = MKCoordinateRegion(
                        center: bostonCoordinates,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                    self.customView.mapView.setRegion(region, animated: true)
                }
                
            case .failure(let error):
                print("Error fetching hospitals: \(error.localizedDescription)")
            }
        }
    }

    private func addAnnotationForAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error for address '\(address)': \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = title
                annotation.subtitle = address
                customView.mapView.addAnnotation(annotation)
                print("title is \(title)")
                print("address is \(address)")
                // Center map on Boston after adding the annotation

            }
        }
    }



    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    // MARK: - Private Methods
    private func setupBindings() {
        // Add action to the buttons
        customView.addMedicalRecordButton.addTarget(self, action: #selector(onAddMedicalRecordTapped), for: .touchUpInside)
        customView.viewMedicalRecordButton.addTarget(self, action: #selector(onViewMedicalRecordTapped), for: .touchUpInside)
        customView.provideAccessButton.addTarget(self, action: #selector(onProvideAccessTapped), for: .touchUpInside)
        customView.reviewAccessButton.addTarget(self, action: #selector(onReviewAccessTapped), for: .touchUpInside)
        //customView.reviewAccessButton.addTarget(self, action: #selector(onReviewAccessTapped), for: .touchUpInside)
        customView.viewInsurersApprovalButton.addTarget(self, action: #selector(onViewInsurersApprovalTapped), for: .touchUpInside)

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
    
    @objc private func onViewInsurersApprovalTapped() {
        // Navigate to the Add Medical Record screen
        let viewInsurerApprovalController = ViewInsurerApprovalController()
        navigationController?.pushViewController(viewInsurerApprovalController, animated: true)
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
