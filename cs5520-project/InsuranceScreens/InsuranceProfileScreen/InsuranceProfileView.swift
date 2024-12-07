import UIKit

class InsuranceProfileView: UIView {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let profileImageView = UIImageView()
    let updateImageButton = UIButton(type: .system)
    let userIdField = UITextField()
    let insuranceCompanyNameField = UITextField()
    let emailField = UITextField()
    let addressField = UITextField()
    let contactInfoField = UITextField()
    let updateButton = UIButton(type: .system)

    // Labels for Text Fields
    let userIdLabel = UILabel()
    let insuranceCompanyNameLabel = UILabel()
    let emailLabel = UILabel()
    let addressLabel = UILabel()
    let contactInfoLabel = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup Views
    private func setupViews() {
        backgroundColor = .white

        // Setup ScrollView and ContentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Profile Image View
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.backgroundColor = .lightGray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)

        // Update Image Button
        updateImageButton.setTitle("Update Image", for: .normal)
        updateImageButton.setTitleColor(.systemBlue, for: .normal)
        updateImageButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(updateImageButton)

        // User ID Field (Disabled)
        setupTextField(userIdField, placeholder: "User ID (Disabled)", isEditable: false, label: userIdLabel)

        // Insurance Company Name Field
        setupTextField(insuranceCompanyNameField, placeholder: "Insurance Company Name", label: insuranceCompanyNameLabel)

        // Email Field (Disabled)
        setupTextField(emailField, placeholder: "Email Address", isEditable: false, label: emailLabel)

        // Address Field
        setupTextField(addressField, placeholder: "Address", label: addressLabel)

        // Contact Info Field
        setupTextField(contactInfoField, placeholder: "Contact No.", label: contactInfoLabel)

        // Update Button
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 8
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(updateButton)
    }

    private func setupTextField(_ textField: UITextField, placeholder: String, isEditable: Bool = true, label: UILabel) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = isEditable
        textField.translatesAutoresizingMaskIntoConstraints = false

        label.text = placeholder
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            // Update Image Button
            updateImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            updateImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // User ID Field
            userIdLabel.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 20),
            userIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            userIdField.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 5),
            userIdField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userIdField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            userIdField.heightAnchor.constraint(equalToConstant: 50),

            // Insurance Company Name Field
            insuranceCompanyNameLabel.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20),
            insuranceCompanyNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            insuranceCompanyNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            insuranceCompanyNameField.topAnchor.constraint(equalTo: insuranceCompanyNameLabel.bottomAnchor, constant: 5),
            insuranceCompanyNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            insuranceCompanyNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            insuranceCompanyNameField.heightAnchor.constraint(equalToConstant: 50),

            // Email Field
            emailLabel.topAnchor.constraint(equalTo: insuranceCompanyNameField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),

            // Address Field
            addressLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            addressField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressField.heightAnchor.constraint(equalToConstant: 50),

            // Contact Info Field
            contactInfoLabel.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 20),
            contactInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            contactInfoField.topAnchor.constraint(equalTo: contactInfoLabel.bottomAnchor, constant: 5),
            contactInfoField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactInfoField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactInfoField.heightAnchor.constraint(equalToConstant: 50),

            // Update Button
            updateButton.topAnchor.constraint(equalTo: contactInfoField.bottomAnchor, constant: 20),
            updateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
