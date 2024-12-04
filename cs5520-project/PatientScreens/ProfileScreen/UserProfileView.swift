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
    
    // Labels for Text Fields
    let userIdLabel = UILabel()
    let fullNameLabel = UILabel()
    let emailLabel = UILabel()
    let insuranceProviderCodeLabel = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupTextFieldObservations()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        setupTextFieldObservations()
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
        setupTextField(userIdField, placeholder: "User ID (Disabled)", isEditable: false, label: userIdLabel)
        
        // Full Name Field
        setupTextField(fullNameField, placeholder: "User's Full Name", label: fullNameLabel)
        
        // Email Field
        setupTextField(emailField, placeholder: "Email Address", label: emailLabel)
        
        // Current Provider Label
        currentProviderLabel.text = "Current Provider Name"
        currentProviderLabel.textColor = .darkGray
        currentProviderLabel.font = UIFont.systemFont(ofSize: 16)
        currentProviderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentProviderLabel)
        
        // Insurance Provider Code Field
        setupTextField(insuranceProviderCodeField, placeholder: "Insurance Provider Code", label: insuranceProviderCodeLabel)
        
        // Update Button
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 8
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(updateButton)
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, isEditable: Bool = true, label: UILabel) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = isEditable
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup label (Initially as placeholder)
        label.text = placeholder
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        addSubview(textField)
    }
    
    private func setupTextFieldObservations() {
        [userIdField, fullNameField, emailField, insuranceProviderCodeField].forEach { textField in
            textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        let label: UILabel
        
        switch sender {
        case userIdField:
            label = userIdLabel
        case fullNameField:
            label = fullNameLabel
        case emailField:
            label = emailLabel
        case insuranceProviderCodeField:
            label = insuranceProviderCodeLabel
        default:
            return
        }
        
        // Show label above text field if text is not empty, otherwise hide it
        if sender.text?.isEmpty == true {
            UIView.animate(withDuration: 0.3) {
                label.isHidden = true
                sender.transform = .identity // Reset text field position
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                label.isHidden = false
                label.transform = CGAffineTransform(translationX: 0, y: 0) // Move label up
                sender.transform = CGAffineTransform(translationX: 0, y: 0) // Push text field down
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image View
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Update Image Button
            updateImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            updateImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // User ID Label and Field
            userIdLabel.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 20),
            userIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            userIdField.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 5),
            userIdField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userIdField.heightAnchor.constraint(equalToConstant: 50),
            
            // Full Name Label and Field
            fullNameLabel.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20),
            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            fullNameField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 5),
            fullNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fullNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fullNameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email Label and Field
            emailLabel.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Current Provider Label
            currentProviderLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            currentProviderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentProviderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Insurance Provider Code Label and Field
            insuranceProviderCodeLabel.topAnchor.constraint(equalTo: currentProviderLabel.bottomAnchor, constant: 20),
            insuranceProviderCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            insuranceProviderCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            insuranceProviderCodeField.topAnchor.constraint(equalTo: insuranceProviderCodeLabel.bottomAnchor, constant: 5),
            insuranceProviderCodeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            insuranceProviderCodeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            insuranceProviderCodeField.heightAnchor.constraint(equalToConstant: 50),
            
            // Update Button
            updateButton.topAnchor.constraint(equalTo: insuranceProviderCodeField.bottomAnchor, constant: 30),
            updateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
