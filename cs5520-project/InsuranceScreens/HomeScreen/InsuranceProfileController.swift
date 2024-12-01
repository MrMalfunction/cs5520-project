import UIKit

class InsuranceProfileController: UIViewController {

    private let profileView = InsuranceProfileView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        displayUserProfile()
    }

    private func setupNavigationBar() {
        title = "Profile"
    }

    private func displayUserProfile() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Unknown Insurance"
        let email = UserDefaults.standard.string(forKey: "email") ?? "Unknown Email"
        profileView.updateProfile(name: username, email: email)
    }
}
