import UIKit

class InsuranceHSController: UIViewController {

    private let customView = InsuranceHSView()

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    // Setup Navigation Bar
    private func setupNavigationBar() {
        title = "Insurance Home" // Main title in navigation bar

        // Profile Button (Left)
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(onProfileButtonTapped)
        )
        navigationItem.leftBarButtonItem = profileButton

        // Logout Button (Right)
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(onLogoutButtonTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func onProfileButtonTapped() {
        let profileController = InsuranceProfileController()
        navigationController?.pushViewController(profileController, animated: true)
    }

    @objc private func onLogoutButtonTapped() {
        // Clear user session and navigate to login
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "userType")
        navigationController?.popToRootViewController(animated: true)
    }
}



   


  






//    @objc private func onPatientsDetailsTapped() {
//        // Example of navigating to another screen
//        let patientsDetailsViewController = PatientsDetailsViewController() // Placeholder controller
//        navigationController?.pushViewController(patientsDetailsViewController, animated: true)
//    }
//
//    @objc private func onPatientsDetailsTapped() {
//        // Debug placeholder
//        print("Patients Details button tapped!")
//        let alert = UIAlertController(title: "Coming Soon", message: "Feature under development.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true)
//    }



