//
//  ViewController.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/20/24.
//

import UIKit

class ViewController: UIViewController {

    private var loginView: LoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        setupActions()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        loginView.showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Setup View
    private func setupLoginView() {
        loginView = LoginView()
        view = loginView
    }
    
    // MARK: - Keyboard Handling
    @objc private func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
        loginView.signupButton.addTarget(self, action: #selector(onSignupButtonTapped), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(onForgotPasswordTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func onLoginButtonTapped() {
        guard let email = loginView.emailField.text, !email.isEmpty,
              let password = loginView.passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        loginUser(email: email, password: password)
    }
    
    @objc private func onSignupButtonTapped() {
        navigateToSignupScreen()
    }
    
    @objc private func onForgotPasswordTapped() {
        navigateToForgotPasswordScreen()
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Login User
    private func loginUser(email: String, password: String) {
        var authHelper = AuthHelper()
        authHelper.login_user(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                print("Login successful.")
                self?.navigateToHomeScreen()
            case .failure(let error):
                self?.showAlert(title: "Login Failed", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToSignupScreen() {
        print("Going to Sign Up")
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    private func navigateToForgotPasswordScreen() {
        print("Going to Forgot Password")
//        let forgotPasswordVC = ForgotPasswordViewController()
//        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    private func navigateToHomeScreen() {
        print("Going to HomeScreen")
//        let homeVC = HomeViewController()
//        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    // MARK: - Show Alert
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Toggle Password Visibility
    @objc private func togglePasswordVisibility() {
        loginView.passwordField.isSecureTextEntry.toggle()
        let buttonTitle = loginView.passwordField.isSecureTextEntry ? "Show" : "Hide"
        loginView.showPasswordButton.setTitle(buttonTitle, for: .normal)
    }

}
