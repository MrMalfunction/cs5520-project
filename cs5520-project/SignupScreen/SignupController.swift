import UIKit

class SignupViewController: UIViewController {
    private let signupView = SignupView()
    private let authHelper = AuthHelper()
    
    // User types for the dropdown
    private let userTypes = ["Patient", "Hospital", "Insurance Company"]
    private var selectedUserType: String?
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupActions()
    }
    
    // MARK: - Setup PickerView
    private func setupPickerView() {
        signupView.userTypePicker.delegate = self
        signupView.userTypePicker.dataSource = self
        // Default selected user type
        selectedUserType = userTypes.first
    }
    
    // MARK: - Actions
    private func setupActions() {
        signupView.signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        // Show password actions
        signupView.passwordShowButton.addTarget(self, action: #selector(didTapShowPassword), for: .touchUpInside)
        signupView.repeatPasswordShowButton.addTarget(self, action: #selector(didTapShowRepeatPassword), for: .touchUpInside)
    }
    
    @objc private func didTapShowPassword() {
        signupView.passwordTextField.isSecureTextEntry.toggle()
        // Update button title based on password visibility
        let title = signupView.passwordTextField.isSecureTextEntry ? "Show" : "Hide"
        signupView.passwordShowButton.setTitle(title, for: .normal)
    }
    
    @objc private func didTapShowRepeatPassword() {
        signupView.repeatPasswordTextField.isSecureTextEntry.toggle()
        // Update button title based on repeat password visibility
        let title = signupView.repeatPasswordTextField.isSecureTextEntry ? "Show" : "Hide"
        signupView.repeatPasswordShowButton.setTitle(title, for: .normal)
    }
    
    @objc private func didTapSignUpButton() {
        guard let name = signupView.nameTextField.text, !name.isEmpty,
              let email = signupView.emailTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let repeatPassword = signupView.repeatPasswordTextField.text, !repeatPassword.isEmpty else {
            showAlert(message: "All fields are required.")
            return
        }
        
        guard password == repeatPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        guard let userType = selectedUserType else {
            showAlert(message: "Please select a user type.")
            return
        }
        
        if userType != "Patient" {
            authHelper.check_business_name(name: name) { [weak self] result in
                switch result {
                case .success:
                    self?.registerUser(name: name, email: email, password: password, userType: userType)
                    
                    switch userType {
                    case "Hospital":
                        self?.authHelper.registerNewHospital(name: name) { result in
                            switch result {
                            case .success():
                                // On success, pop to the root view controller
                                self?.showAlert(message: "Hospital User registered successfully.")
                                DispatchQueue.main.async {
                                    self?.navigationController?.popToRootViewController(animated: true)
                                }
                            case .failure(let error):
                                // On failure, use showAlert to display the error message
                                DispatchQueue.main.async {
                                    self?.showAlert(message: "Error registering hospital: \(error.localizedDescription)") {
                                        // You can optionally perform additional actions after alert is dismissed, if needed
                                    }
                                }
                            }
                        }
                    case "Insurance Company":
                        self?.authHelper.registerNewInsurance(name: name) { result in
                            switch result {
                            case .success():
                                self?.showAlert(message: "Insurance Company User registered successfully.")
                                // On success, pop to the root view controller
                                DispatchQueue.main.async {
                                    self?.navigationController?.popToRootViewController(animated: true)
                                }
                            case .failure(let error):
                                // On failure, use showAlert to display the error message
                                DispatchQueue.main.async {
                                    self?.showAlert(message: "Error registering insurance company: \(error.localizedDescription)") {
                                        // You can optionally perform additional actions after alert is dismissed, if needed
                                    }
                                }
                            }
                        }
                    default:
                        print("INCORRECT USER TPYE")
                    }

                    
                    self?.navigationController?.popViewController(animated: true)
                case .failure:
                    self?.showAlert(message: "Business name already exists.")
                }
            }
        } else {
            registerUser(name: name, email: email, password: password, userType: userType)
        }
    }
    
    private func registerUser(name: String, email: String, password: String, userType: String) {
        authHelper.register_user(name: name, email: email, password: password, userType: userType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showAlert(message: "User registered successfully.") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    self?.showAlert(message: "Failed to register user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypes[row]
    }
    
    // Remove return type here because this method doesn't need to return anything
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUserType = userTypes[row]
    }
}
