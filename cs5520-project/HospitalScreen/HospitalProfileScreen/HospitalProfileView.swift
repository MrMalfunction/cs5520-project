
import UIKit

class HospitalProfileView: UIView {

    // MARK: - UI Components
    let profileImageView = UIImageView()
    let updateImageButton = UIButton(type: .system)
    let userIdField = UITextField()
    let hospitalNameField = UITextField()
    let emailField = UITextField()
    let addressField = UITextField()
    let contactInfoField = UITextField()
    let updateButton = UIButton(type: .system)

    // Labels for Text Fields
    let userIdLabel = UILabel()
    let hospitalNameLabel = UILabel()
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

        // Hospital Name Field
        setupTextField(hospitalNameField, placeholder: "Hospital Name", label: hospitalNameLabel)

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
        addSubview(updateButton)
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
        addSubview(label)
        addSubview(textField)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            updateImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            updateImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            userIdLabel.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 20),
            userIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            userIdField.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 5),
            userIdField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userIdField.heightAnchor.constraint(equalToConstant: 50),

            hospitalNameLabel.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20),
            hospitalNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hospitalNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            hospitalNameField.topAnchor.constraint(equalTo: hospitalNameLabel.bottomAnchor, constant: 5),
            hospitalNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hospitalNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hospitalNameField.heightAnchor.constraint(equalToConstant: 50),

            emailLabel.topAnchor.constraint(equalTo: hospitalNameField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),

            addressLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            addressField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addressField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addressField.heightAnchor.constraint(equalToConstant: 50),

            contactInfoLabel.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 20),
            contactInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contactInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            contactInfoField.topAnchor.constraint(equalTo: contactInfoLabel.bottomAnchor, constant: 5),
            contactInfoField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contactInfoField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contactInfoField.heightAnchor.constraint(equalToConstant: 50),

            updateButton.topAnchor.constraint(equalTo: contactInfoField.bottomAnchor, constant: 20),
            updateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
