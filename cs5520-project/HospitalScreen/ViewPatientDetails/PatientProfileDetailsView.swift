
import UIKit

class PatientProfileDetailsView: UIView {
    
    // MARK: - UI Elements
    let profileImageView = UIImageView()
    
    // Labels
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let dobLabel = UILabel()
    let genderLabel = UILabel()
    let bloodGroupLabel = UILabel()
    let userIdLabel = UILabel()
    let userTypeLabel = UILabel()
    let linkedHospitalsLabel = UILabel()
    let linkedInsurersLabel = UILabel()
    
    // Fields
    let nameField = UITextField()
    let emailField = UITextField()
    let dobField = UITextField()
    let genderField = UITextField()
    let bloodGroupField = UITextField()
    let userIdField = UITextField()
    let userTypeField = UITextField()
    let linkedHospitalsField = UITextView()
    let linkedInsurersField = UITextView()
    
    // MARK: - Initializer
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
        
        // Setup Profile Image View
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView)
        
        // Setup Labels and Fields
        setupLabelAndField(label: nameLabel, field: nameField, labelText: "Name")
        setupLabelAndField(label: emailLabel, field: emailField, labelText: "Email")
        setupLabelAndField(label: dobLabel, field: dobField, labelText: "Date of Birth")
        setupLabelAndField(label: genderLabel, field: genderField, labelText: "Gender")
        setupLabelAndField(label: bloodGroupLabel, field: bloodGroupField, labelText: "Blood Group")
        setupLabelAndField(label: userIdLabel, field: userIdField, labelText: "User ID")
        setupLabelAndField(label: userTypeLabel, field: userTypeField, labelText: "User Type")
        
        // Setup Multi-line Fields
        setupTextView(linkedHospitalsLabel, linkedHospitalsField, labelText: "Linked Hospitals")
        setupTextView(linkedInsurersLabel, linkedInsurersField, labelText: "Linked Insurers")
    }
    
    private func setupLabelAndField(label: UILabel, field: UITextField, labelText: String) {
        label.text = labelText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        addSubview(field)
    }
    
    private func setupTextView(_ label: UILabel, _ textView: UITextView, labelText: String) {
        label.text = labelText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -10),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Email
            emailLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Date of Birth
            dobLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            dobLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dobField.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 5),
            dobField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dobField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Gender
            genderLabel.topAnchor.constraint(equalTo: dobField.bottomAnchor, constant: 10),
            genderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            genderField.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5),
            genderField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            genderField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Blood Group
            bloodGroupLabel.topAnchor.constraint(equalTo: genderField.bottomAnchor, constant: 10),
            bloodGroupLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bloodGroupField.topAnchor.constraint(equalTo: bloodGroupLabel.bottomAnchor, constant: 5),
            bloodGroupField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bloodGroupField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // User ID
            userIdLabel.topAnchor.constraint(equalTo: bloodGroupField.bottomAnchor, constant: 10),
            userIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdField.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 5),
            userIdField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // User Type
            userTypeLabel.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 10),
            userTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userTypeField.topAnchor.constraint(equalTo: userTypeLabel.bottomAnchor, constant: 5),
            userTypeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userTypeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Linked Hospitals
            linkedHospitalsLabel.topAnchor.constraint(equalTo: userTypeField.bottomAnchor, constant: 10),
            linkedHospitalsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            linkedHospitalsField.topAnchor.constraint(equalTo: linkedHospitalsLabel.bottomAnchor, constant: 5),
            linkedHospitalsField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            linkedHospitalsField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            linkedHospitalsField.heightAnchor.constraint(equalToConstant: 40),
            
            // Linked Insurers
            linkedInsurersLabel.topAnchor.constraint(equalTo: linkedHospitalsField.bottomAnchor, constant: 10),
            linkedInsurersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            linkedInsurersField.topAnchor.constraint(equalTo: linkedInsurersLabel.bottomAnchor, constant: 5),
            linkedInsurersField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            linkedInsurersField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            linkedInsurersField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

}
