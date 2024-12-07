
import UIKit

class SignupView: UIView {
    // MARK: - UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    let appLabel = UILabel()
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let repeatPasswordTextField = UITextField()
    let userTypePickerLabel = UILabel() // New label for user type picker
    let userTypePicker = UIPickerView()
    let signUpButton = UIButton(type: .system)
    
    // Show password buttons
    let passwordShowButton = UIButton(type: .system)
    let repeatPasswordShowButton = UIButton(type: .system)
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        
        // Configure scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        // Configure content view inside scroll view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Configure app label
        appLabel.text = "Sign Up for HealthKey"
        appLabel.font = UIFont.boldSystemFont(ofSize: 28)
        appLabel.textAlignment = .center
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure text fields
        [nameTextField, emailTextField, passwordTextField, repeatPasswordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameTextField.placeholder = "Name"
        emailTextField.placeholder = "Email"
        emailTextField.autocapitalizationType = .none
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.placeholder = "Repeat Password"
        repeatPasswordTextField.isSecureTextEntry = true
        
        // Configure password show buttons
        passwordShowButton.setTitle("Show", for: .normal)
        passwordShowButton.translatesAutoresizingMaskIntoConstraints = false
        repeatPasswordShowButton.setTitle("Show", for: .normal)
        repeatPasswordShowButton.translatesAutoresizingMaskIntoConstraints = false

        
        // Configure user type picker label (new label)
        userTypePickerLabel.text = "Which kind of user are you?"
        userTypePickerLabel.font = UIFont.systemFont(ofSize: 16)
        userTypePickerLabel.textAlignment = .left
        userTypePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure picker view
        userTypePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure sign-up button (Full width, filled with system blue, and bigger text)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .systemBlue // Set a fill color (e.g., blue)
        signUpButton.setTitleColor(.white, for: .normal)  // White text color for contrast
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)  // Bigger text size
        signUpButton.layer.cornerRadius = 8  // Optional: Rounded corners for the button
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        
        // Add subviews to content view
        [appLabel, nameTextField, emailTextField, passwordTextField, repeatPasswordTextField, userTypePickerLabel, userTypePicker, signUpButton, passwordShowButton, repeatPasswordShowButton].forEach {
            contentView.addSubview($0)
        }
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // ContentView constraints (inside the scroll view)
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // App label constraints
            appLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            appLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Name text field constraints
            nameTextField.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Email text field constraints
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Password text field constraints
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60), // Adjusted to create space for the button
            
            // Show password button constraints
            passwordShowButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordShowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Repeat password text field constraints
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60), // Adjusted to create space for the button
            
            // Show repeat password button constraints
            repeatPasswordShowButton.centerYAnchor.constraint(equalTo: repeatPasswordTextField.centerYAnchor),
            repeatPasswordShowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // User type picker label constraints (new label)
            userTypePickerLabel.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 15),
            userTypePickerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userTypePickerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // User type picker constraints
            userTypePicker.topAnchor.constraint(equalTo: userTypePickerLabel.bottomAnchor, constant: 5),
            userTypePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userTypePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            userTypePicker.heightAnchor.constraint(equalToConstant: 100),
            
            // Sign-up button constraints
               signUpButton.topAnchor.constraint(equalTo: userTypePicker.bottomAnchor, constant: 20),
               signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
               signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
               signUpButton.heightAnchor.constraint(equalToConstant: 50),  // Set a fixed height for the button
               signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Ensuring it's at the bottom
        ])
    }
}
