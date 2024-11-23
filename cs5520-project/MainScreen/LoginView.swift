//
//  LoginView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/23/24.
//

//
//  LoginView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/23/24.
//

import UIKit

class LoginView: UIView {
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to HealthKey"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private var contentWrapper: UIScrollView!
    private var stackView: UIStackView!
    
    var emailField: UITextField!
    var passwordField: UITextField!
    var loginButton: UIButton!
    var signupButton: UIButton!
    var forgotPasswordButton: UIButton!
    var showPasswordButton: UIButton!

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupContentWrapper()
        setupStackView()
        setupUIElements()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        setupContentWrapper()
        setupStackView()
        setupUIElements()
        initConstraints()
    }
    
    // MARK: - UI Setup
    private func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.alwaysBounceVertical = true
        addSubview(contentWrapper)
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(stackView)
    }
    
    private func setupUIElements() {
        stackView.addArrangedSubview(titleLabel)
        
        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emailField)
        
        let passwordContainer = UIView()
        passwordContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true

        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordContainer.addSubview(passwordField)
        
        showPasswordButton = UIButton(type: .system)
        showPasswordButton.setTitle("Show", for: .normal)
        showPasswordButton.titleLabel?.font = .systemFont(ofSize: 14)
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        passwordContainer.addSubview(showPasswordButton)

        stackView.addArrangedSubview(passwordContainer)
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 8
        stackView.addArrangedSubview(loginButton)
        
        signupButton = UIButton(type: .system)
        signupButton.setTitle("Signup", for: .normal)
        stackView.addArrangedSubview(signupButton)
        
        forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        stackView.addArrangedSubview(forgotPasswordButton)
    }
    
    // MARK: - Constraints Setup
    private func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, constant: -40),
            
            emailField.heightAnchor.constraint(equalToConstant: 44),
            
            // Password Field Constraints
            passwordField.leadingAnchor.constraint(equalTo: passwordField.superview!.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor, constant: -8),
            passwordField.centerYAnchor.constraint(equalTo: passwordField.superview!.centerYAnchor),
            
            // Show Password Button Constraints
            showPasswordButton.trailingAnchor.constraint(equalTo: showPasswordButton.superview!.trailingAnchor),
            showPasswordButton.centerYAnchor.constraint(equalTo: showPasswordButton.superview!.centerYAnchor),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 60),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
