//
//  UserProfileView.swift
//  cs5520-project
//
//  Created by MAD6 on 11/29/24.
//


//import UIKit
//
//class UserProfileView: UIView {
//    
//    // MARK: - UI Components
//    let userIdField = UITextField()
//    let fullNameField = UITextField()
//    let updateImageButton = UIButton(type: .system)
//    let emailField = UITextField()
//    let currentProviderLabel = UILabel()
//    let insuranceProviderCodeField = UITextField()
//    let updateButton = UIButton(type: .system)
//    
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//        setupConstraints()
//    }
//    
//    private func setupViews() {
//        backgroundColor = .white
//        
//        // User ID Field (Disabled)
//        setupTextField(userIdField, placeholder: "User ID (Disabled)", isEditable: false)
//        
//        // Full Name Field
//        setupTextField(fullNameField, placeholder: "User's Full Name")
//        
//        // Update Image Button
//        updateImageButton.setTitle("Update Image", for: .normal)
//        updateImageButton.setTitleColor(.systemBlue, for: .normal)
//        updateImageButton.layer.borderWidth = 1
//        updateImageButton.layer.borderColor = UIColor.systemBlue.cgColor
//        updateImageButton.layer.cornerRadius = 8
//        updateImageButton.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(updateImageButton)
//        
//        // Email Field
//        setupTextField(emailField, placeholder: "Email Address")
//        
//        // Current Provider Label
//        currentProviderLabel.text = "Current Provider Name"
//        currentProviderLabel.textColor = .darkGray
//        currentProviderLabel.font = UIFont.systemFont(ofSize: 16)
//        currentProviderLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(currentProviderLabel)
//        
//        // Insurance Provider Code Field
//        setupTextField(insuranceProviderCodeField, placeholder: "Insurance Provider Code")
//        
//        // Update Button
//        updateButton.setTitle("Update", for: .normal)
//        updateButton.backgroundColor = .systemBlue
//        updateButton.setTitleColor(.white, for: .normal)
//        updateButton.layer.cornerRadius = 8
//        updateButton.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(updateButton)
//    }
//    
//    private func setupTextField(_ textField: UITextField, placeholder: String, isEditable: Bool = true) {
//        textField.placeholder = placeholder
//        textField.borderStyle = .roundedRect
//        textField.isUserInteractionEnabled = isEditable
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(textField)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            userIdField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
//            userIdField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            userIdField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            userIdField.heightAnchor.constraint(equalToConstant: 50),
//            
//            fullNameField.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20),
//            fullNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            fullNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            fullNameField.heightAnchor.constraint(equalToConstant: 50),
//            
//            updateImageButton.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
//            updateImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            updateImageButton.widthAnchor.constraint(equalToConstant: 200),
//            updateImageButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            emailField.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 20),
//            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            emailField.heightAnchor.constraint(equalToConstant: 50),
//            
//            currentProviderLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
//            currentProviderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            currentProviderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            
//            insuranceProviderCodeField.topAnchor.constraint(equalTo: currentProviderLabel.bottomAnchor, constant: 20),
//            insuranceProviderCodeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            insuranceProviderCodeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            insuranceProviderCodeField.heightAnchor.constraint(equalToConstant: 50),
//            
//            updateButton.topAnchor.constraint(equalTo: insuranceProviderCodeField.bottomAnchor, constant: 30),
//            updateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            updateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            updateButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//}

import UIKit
class UserProfileView: UIView {
    
    // MARK: - UI Components
    let profileImageView = UIImageView()
    let updateImageButton = UIButton(type: .system)
    let userIdField = UITextField()
    let fullNameField = UITextField()
    let emailField = UITextField()
    let currentProviderLabel = UILabel()
    let insuranceProviderCodeField = UITextField()
    let updateButton = UIButton(type: .system)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        // Profile Image View
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.backgroundColor = .lightGray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView)
        
        // Update Image Button
        updateImageButton.setTitle("Update Image", for: .normal)
        updateImageButton.setTitleColor(.systemBlue, for: .normal)
        updateImageButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(updateImageButton)
        
        // User ID Field (Disabled)
        setupTextField(userIdField, placeholder: "User ID (Disabled)", isEditable: false)
        
        // Full Name Field
        setupTextField(fullNameField, placeholder: "User's Full Name")
        
        // Email Field
        setupTextField(emailField, placeholder: "Email Address")
        
        // Current Provider Label
        currentProviderLabel.text = "Current Provider Name"
        currentProviderLabel.textColor = .darkGray
        currentProviderLabel.font = UIFont.systemFont(ofSize: 16)
        currentProviderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentProviderLabel)
        
        // Insurance Provider Code Field
        setupTextField(insuranceProviderCodeField, placeholder: "Insurance Provider Code")
        
        // Update Button
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 8
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(updateButton)
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, isEditable: Bool = true) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = isEditable
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        if !isEditable {
            textField.backgroundColor = UIColor.systemGray5 // Gray background
            textField.textColor = UIColor.lightGray // Lighter text color
        }
        
        addSubview(textField)
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            updateImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            updateImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            userIdField.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 20),
            userIdField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userIdField.heightAnchor.constraint(equalToConstant: 50),
            
            fullNameField.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20),
            fullNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fullNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fullNameField.heightAnchor.constraint(equalToConstant: 50),
            
            emailField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            currentProviderLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            currentProviderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentProviderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            insuranceProviderCodeField.topAnchor.constraint(equalTo: currentProviderLabel.bottomAnchor, constant: 20),
            insuranceProviderCodeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            insuranceProviderCodeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            insuranceProviderCodeField.heightAnchor.constraint(equalToConstant: 50),
            
            updateButton.topAnchor.constraint(equalTo: insuranceProviderCodeField.bottomAnchor, constant: 30),
            updateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
