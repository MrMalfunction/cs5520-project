import UIKit

class UserProfileView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - UI Components
    var contentWrapper:UIScrollView!
    let profileImageView = UIImageView()
    let updateImageButton = UIButton(type: .system)
    let userIdField = UITextField()
    let fullNameField = UITextField()
    let emailField = UITextField()
    
    let dobPicker = UIDatePicker()
    let genderPicker = UIPickerView()
    let bloodGroupPicker = UIPickerView()
    let dobPickerLabel = UILabel()

    // Data for Pickers
    let genderOptions = ["M", "F", "*"]
    let bloodGroupOptions = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    
    // Selected Fields
    var selectedGender: String?
    var selectedBloodGroup: String?
    var selectedDOB: Date?
    
    let currentProviderLabel = UILabel()
    let updateButton = UIButton(type: .system)
    let insuranceProviderCodeField = UITextField()
    
    // Labels for Text Fields
    let userIdLabel = UILabel()
    let fullNameLabel = UILabel()
    let emailLabel = UILabel()
    let insuranceProviderCodeLabel = UILabel()
    
    // Picker for Insurance Providers
    let insuranceProviderPicker = UIPickerView()
    
    // Data for Picker (Will be populated by the controller)
    var insuranceProviders: [String] = [] {
        didSet {
            insuranceProviderPicker.reloadAllComponents()
        }
    }
    
    // Selected Provider
    var selectedProvider: String? {
        didSet {
            insuranceProviderCodeField.text = selectedProvider
        }
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentWrapper()
        setupViews()
        setupConstraints()
        setupTextFieldObservations()
        /*setupPickerView*/()
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
        contentWrapper.addSubview(profileImageView)
        
        // Update Image Button
        updateImageButton.setTitle("Update Image", for: .normal)
        updateImageButton.setTitleColor(.systemBlue, for: .normal)
        updateImageButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(updateImageButton)
        
        // User ID Field (Disabled)
        setupTextField(userIdField, placeholder: "User ID (Disabled)", isEditable: false, label: userIdLabel)
        
        // Full Name Field
        setupTextField(fullNameField, placeholder: "User's Full Name", label: fullNameLabel)
        
        // Email Field (Disabled)
        setupTextField(emailField, placeholder: "Email Address (Disabled)", isEditable: false, label: emailLabel)
        
        // Current Provider Label
        dobPickerLabel.text = "\t\tDate of Birth \t\t Gender \t Blood Group"
        dobPickerLabel.textColor = .darkGray
        dobPickerLabel.font = UIFont.systemFont(ofSize: 16)
        dobPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(dobPickerLabel)
        
        dobPicker.datePickerMode = .date
        dobPicker.preferredDatePickerStyle = .wheels
        dobPicker.translatesAutoresizingMaskIntoConstraints = false
        dobPicker.addTarget(self, action: #selector(didChangeDOB), for: .valueChanged)
        contentWrapper.addSubview(dobPicker)
        
        setupPicker(genderPicker)
        setupPicker(bloodGroupPicker)
        
        contentWrapper.addSubview(genderPicker)
        contentWrapper.addSubview(bloodGroupPicker)
        
        // Current Provider Label
        currentProviderLabel.text = "Current Provider Name"
        currentProviderLabel.textColor = .darkGray
        currentProviderLabel.font = UIFont.systemFont(ofSize: 16)
        currentProviderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentWrapper.addSubview(currentProviderLabel)
        
        // Insurance Provider Code Field (Dropdown)
        setupTextField(insuranceProviderCodeField, placeholder: "Select Insurance Provider", label: insuranceProviderCodeLabel)
        insuranceProviderCodeField.inputView = insuranceProviderPicker
        
        // Update Button
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 8
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(updateButton)
    }
    
    private func setupPicker(_ picker: UIPickerView) {
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
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
        contentWrapper.addSubview(label)
        
        contentWrapper.addSubview(textField)
    }
    
    private func setupTextFieldObservations() {
        [userIdField, fullNameField, emailField].forEach { textField in
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
        default:
            return
        }
        
        if sender.text?.isEmpty == true {
            UIView.animate(withDuration: 0.3) {
                label.isHidden = true
                sender.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                label.isHidden = false
                label.transform = .identity
                sender.transform = .identity
            }
        }
    }
    
    // MARK: - Picker View Setup
//    private func setupPickerView() {
//        insuranceProviderPicker.dataSource = self
//        insuranceProviderPicker.delegate = self
//    }
    
    // MARK: - Picker View Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case genderPicker: return genderOptions.count
        case bloodGroupPicker: return bloodGroupOptions.count
        case insuranceProviderPicker: return insuranceProviders.count
        default: return 0
        }
    }
    
    // MARK: - Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
         case genderPicker: return genderOptions[row]
         case bloodGroupPicker: return bloodGroupOptions[row]
         case insuranceProviderPicker: return insuranceProviders[row]
         default: return nil
         }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPicker:
            selectedGender = genderOptions[row]
        case bloodGroupPicker:
            selectedBloodGroup = bloodGroupOptions[row]
        case insuranceProviderPicker:
            selectedProvider = insuranceProviders[row]
            insuranceProviderCodeField.resignFirstResponder()
        default:
            break
        }
    }
    
    @objc private func didChangeDOB() {
        selectedDOB = dobPicker.date
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            updateImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            updateImageButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            userIdLabel.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 20),
            userIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            userIdField.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 5),
            userIdField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userIdField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userIdField.heightAnchor.constraint(equalToConstant: 50),
            
            fullNameLabel.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20),
            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            fullNameField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 5),
            fullNameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fullNameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fullNameField.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            dobPickerLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: -20),
            dobPickerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dobPickerLabel.heightAnchor.constraint(equalToConstant: 90),
//            dobPickerLabel.widthAnchor.constraint(equalToConstant: 180),
            
            dobPicker.topAnchor.constraint(equalTo: dobPickerLabel.bottomAnchor, constant: -25),
            dobPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dobPicker.heightAnchor.constraint(equalToConstant: 90),
            dobPicker.widthAnchor.constraint(equalToConstant: 180),
            
            genderPicker.topAnchor.constraint(equalTo: dobPickerLabel.bottomAnchor, constant: -25),
            genderPicker.leadingAnchor.constraint(equalTo: dobPicker.trailingAnchor, constant: -15),
            genderPicker.heightAnchor.constraint(equalToConstant: 90),
            genderPicker.widthAnchor.constraint(equalToConstant: 60),
            
            bloodGroupPicker.topAnchor.constraint(equalTo: dobPickerLabel.bottomAnchor, constant: -25),
            bloodGroupPicker.leadingAnchor.constraint(equalTo: genderPicker.trailingAnchor, constant: -15),
            bloodGroupPicker.widthAnchor.constraint(equalToConstant: 90),
            bloodGroupPicker.heightAnchor.constraint(equalToConstant: 90),
            bloodGroupPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            currentProviderLabel.topAnchor.constraint(equalTo: bloodGroupPicker.bottomAnchor, constant: 0),
            currentProviderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentProviderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            insuranceProviderCodeLabel.topAnchor.constraint(equalTo: currentProviderLabel.bottomAnchor, constant: 20),
            insuranceProviderCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            insuranceProviderCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            insuranceProviderCodeField.topAnchor.constraint(equalTo: insuranceProviderCodeLabel.bottomAnchor, constant: 5),
            insuranceProviderCodeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            insuranceProviderCodeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            insuranceProviderCodeField.heightAnchor.constraint(equalToConstant: 50),
            
            updateButton.topAnchor.constraint(equalTo: insuranceProviderCodeField.bottomAnchor, constant: 20),
            updateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),
        ])
    }
}
