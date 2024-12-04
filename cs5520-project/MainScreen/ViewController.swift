//
//  ViewController.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/20/24.
//

import UIKit

class ViewController: UIViewController {

    private var loginView: LoginView!
    private let authHelper = AuthHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        autoLogin()
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
    
    // MARK: - Auto Login
    private func autoLogin(){
        if (UserDefaults.standard.string(forKey: "userType") ?? "" != "" && UserDefaults.standard.string(forKey: "uid") ?? "" != "" && self.authHelper.login_check()){
            navigateToHomeScreen()
        }
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
        self.authHelper.login_user(email: email, password: password) { [weak self] result in
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
        let forgotPasswordVC = ResetPasswordViewController()
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    private func navigateToHomeScreen() {

        let userType = UserDefaults.standard.string(forKey: "userType") ?? ""

        if userType.isEmpty {
            showAlert(title: "Error", message: "User type is not set. Please configure it in settings.")
        } else {
            // Safely unwrap the text values
            if self.loginView.emailField.text != nil {
                loginView.emailField.text = "" // Reset text if it exists
            }
                
            if self.loginView.passwordField.text != nil {
                loginView.passwordField.text = "" // Reset text if it exists
            }
            switch userType {
            case "Patient":
                let patientHS = PatientHSController()
                navigationController?.pushViewController(patientHS, animated: true)
                
            case "Hospital":
                let hospitalHS = HospitalHSController()
                navigationController?.pushViewController(hospitalHS, animated: true)
                
            case "Insurance Company":
                let insuranceHS = InsuranceHSController()
                navigationController?.pushViewController(insuranceHS, animated: true)
                
            default:
                print("Unknown user type")
                showAlert(title: "Error", message: "Unknown user type. Please contact support.")
            }
        }
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
