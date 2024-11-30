//
//  AddMedicalRecordView.swift
//  cs5520-project
//
//  Created by MAD6 on 11/25/24.
//

import UIKit

class AddPatientRecordView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ScrollView and ContentView
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Dropdown Options
    private let genderOptions = ["Male", "Female"]
    private let maritalStatusOptions = ["Married", "Single", "Divorced", "Separated"]
    private let employmentOptions = ["Employed", "Self Employed", "Unemployed", "Other"]
    
    // Picker Views
    private let genderPicker = UIPickerView()
    private let maritalStatusPicker = UIPickerView()
    private let employmentPicker = UIPickerView()
    
    // Date Picker
    private let datePicker = UIDatePicker()
    
    // Patient Information Fields
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    let preferredNameField = UITextField()
    let patientIdentifierField = UITextField()
    let genderField = UITextField()
    let preferredPronounsField = UITextField()
    let dobField = UITextField()
    let maritalStatusField = UITextField()
    let addressField = UITextField()
    let cityField = UITextField()
    let stateField = UITextField()
    let zipCodeField = UITextField()
    let emailField = UITextField()
    let phoneNumberField = UITextField()
    
    // Emergency Contact Fields
    let emergencyContact1NameField = UITextField()
    let emergencyContact1RelationField = UITextField()
    let emergencyContact1NumberField = UITextField()
    let emergencyContact2NameField = UITextField()
    let emergencyContact2RelationField = UITextField()
    let emergencyContact2NumberField = UITextField()
    
    // Health and Medical Information Fields
    let primaryCarePhysicianField = UITextField()
    let physicianAddressField = UITextField()
    let physicianContactField = UITextField()
    let medicalConditionsField = UITextView()
    let medicationsField = UITextView()
    
    // Insurance Information Fields
    let insuranceCarrierField = UITextField()
    let insurancePlanField = UITextField()
    let policyNumberField = UITextField()
    let groupNumberField = UITextField()
    let ssnField = UITextField()
    
    // Employment Status and Details Fields
    let employmentStatusField = UITextField()
    let occupationField = UITextField()
    let industryField = UITextField()
    let companyNameField = UITextField()
    let companyAddressField = UITextField()
    let companyCityField = UITextField()
    let companyStateField = UITextField()
    let companyZipCodeField = UITextField()
    
    // Save Button
    let saveButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        // Configure ScrollView and ContentView
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add placeholders to fields
        let textFields: [(UITextField, String)] = [
            (firstNameField, "First Name"), (lastNameField, "Last Name"), (preferredNameField, "Preferred Name"),
            (patientIdentifierField, "Patient Identifier"), (genderField, "Gender (Dropdown)"),
            (preferredPronounsField, "Preferred Pronouns"), (dobField, "Date of Birth (Select Date)"),
            (maritalStatusField, "Marital Status (Dropdown)"), (addressField, "Address"), (cityField, "City"),
            (stateField, "State"), (zipCodeField, "Zip Code"), (emailField, "Email"), (phoneNumberField, "Phone Number"),
            (emergencyContact1NameField, "Emergency Contact 1 Name"), (emergencyContact1RelationField, "Relationship"),
            (emergencyContact1NumberField, "Contact Number"), (emergencyContact2NameField, "Emergency Contact 2 Name"),
            (emergencyContact2RelationField, "Relationship"), (emergencyContact2NumberField, "Contact Number"),
            (primaryCarePhysicianField, "Primary Care Physician"), (physicianAddressField, "Physician Address"),
            (physicianContactField, "Physician Contact"), (insuranceCarrierField, "Insurance Carrier"),
            (insurancePlanField, "Insurance Plan"), (policyNumberField, "Policy Number"),
            (groupNumberField, "Group Number"), (ssnField, "Social Security Number"),
            (employmentStatusField, "Employment Status (Dropdown)")
        ]
        
        for (field, placeholder) in textFields {
            field.borderStyle = .roundedRect
            field.placeholder = placeholder
            field.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Configure Dropdown Fields
        configurePickerView(pickerView: genderPicker, textField: genderField, options: genderOptions)
        configurePickerView(pickerView: maritalStatusPicker, textField: maritalStatusField, options: maritalStatusOptions)
        configurePickerView(pickerView: employmentPicker, textField: employmentStatusField, options: employmentOptions)
        
        // Configure Date Picker
        configureDatePicker(textField: dobField)
        
        // Configure TextViews
        medicalConditionsField.layer.borderColor = UIColor.gray.cgColor
        medicalConditionsField.layer.borderWidth = 1
        medicalConditionsField.layer.cornerRadius = 8
        medicalConditionsField.text = "List any medical conditions"
        medicalConditionsField.translatesAutoresizingMaskIntoConstraints = false
        
        medicationsField.layer.borderColor = UIColor.gray.cgColor
        medicationsField.layer.borderWidth = 1
        medicationsField.layer.cornerRadius = 8
        medicationsField.text = "List any current medications"
        medicationsField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add all fields and views to contentView
        let allFields: [UIView] = textFields.map { $0.0 } + [medicalConditionsField, medicationsField, saveButton]
        allFields.forEach { contentView.addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Position fields vertically
        var previousView: UIView? = nil
        let padding: CGFloat = 16
        
        for view in contentView.subviews {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
                view.heightAnchor.constraint(equalToConstant: (view is UITextView) ? 100 : 44)
            ])
            
            if let previous = previousView {
                view.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: padding).isActive = true
            } else {
                view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
            }
            
            previousView = view
        }
        
        saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
    }
    
    private func configurePickerView(pickerView: UIPickerView, textField: UITextField, options: [String]) {
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        textField.tag = pickerView.hashValue
    }
    
    private func configureDatePicker(textField: UITextField) {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        textField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDoneTapped))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func datePickerDoneTapped() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dobField.text = formatter.string(from: datePicker.date)
        dobField.resignFirstResponder()
    }
    
    // MARK: - UIPickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderPicker: return genderOptions.count
        case maritalStatusPicker: return maritalStatusOptions.count
        case employmentPicker: return employmentOptions.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPicker: return genderOptions[row]
        case maritalStatusPicker: return maritalStatusOptions[row]
        case employmentPicker: return employmentOptions[row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPicker:
            genderField.text = genderOptions[row]
            genderField.resignFirstResponder()
        case maritalStatusPicker:
            maritalStatusField.text = maritalStatusOptions[row]
            maritalStatusField.resignFirstResponder()
        case employmentPicker:
            employmentStatusField.text = employmentOptions[row]
            employmentStatusField.resignFirstResponder()
        default: break
        }
    }
}
