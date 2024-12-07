
import UIKit

class ResetPasswordViewController: UIViewController {
    
    // MARK: - Properties
    private let resetPasswordView = ResetPasswordView()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = resetPasswordView
        resetPasswordView.resetButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
    }
    
    // MARK: - Reset Button Action
    @objc private func didTapResetButton() {
        guard let email = resetPasswordView.emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email address.")
            return
        }
        
        resetPassword(email: email)
    }
    
    // MARK: - Reset Password
    private func resetPassword(email: String) {
        let authHelper = AuthHelper()
        
        authHelper.reset_password(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.showAlert(message: "Password reset email sent. Please check your inbox."){
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
        
    // MARK: - Helper Methods
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true, completion: nil)
    }
}
