//
//  AddMedicalRecordView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/5/24.
//
import UIKit

class AddMedicalRecordView: UIView, UITextViewDelegate {
    
    // ScrollView and Content View
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    let recordTypeLabel = UILabel()
    let recordTypePicker = UIPickerView()
    let recordValueTextField = UITextField()
    let commentsTextField = UITextView()
    private let commentsPlaceholderLabel = UILabel() // Placeholder for comments field
    let saveButton = UIButton(type: .system)
    
    // Picker Data for Record Type
    let recordTypeOptions = ["Blood Glucose Level", "Blood Cholesterol Level", "Blood Pressure", "Other"]
    
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
        
        // Configure Record Type Label
        recordTypeLabel.text = "Select Record Type"
        recordTypeLabel.textAlignment = .center
        recordTypeLabel.font = UIFont.systemFont(ofSize: 20)
        recordTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recordTypeLabel)
        
        // Configure Record Type Picker
        recordTypePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recordTypePicker)
        
        // Configure Record Value Text Field
        recordValueTextField.placeholder = "Report Value"
        recordValueTextField.textAlignment = .center
        recordValueTextField.font = UIFont.systemFont(ofSize: 20)
        recordValueTextField.borderStyle = .roundedRect
        recordValueTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recordValueTextField)
        
        // Configure Comments Text Field
        commentsTextField.layer.borderWidth = 1
        commentsTextField.layer.borderColor = UIColor.lightGray.cgColor
        commentsTextField.layer.cornerRadius = 8
        commentsTextField.font = UIFont.systemFont(ofSize: 16)
        commentsTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        commentsTextField.translatesAutoresizingMaskIntoConstraints = false
        commentsTextField.delegate = self
        contentView.addSubview(commentsTextField)
        
        // Configure Placeholder Label
        commentsPlaceholderLabel.text = "Comments"
        commentsPlaceholderLabel.textColor = .lightGray
        commentsPlaceholderLabel.font = UIFont.systemFont(ofSize: 16)
        commentsPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsTextField.addSubview(commentsPlaceholderLabel)
        
        // Configure Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.textAlignment = .center
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Record Type Label Constraints
        NSLayoutConstraint.activate([
            recordTypeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            recordTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recordTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recordTypeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Record Type Picker Constraints
        NSLayoutConstraint.activate([
            recordTypePicker.topAnchor.constraint(equalTo: recordTypeLabel.bottomAnchor, constant: 8),
            recordTypePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recordTypePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recordTypePicker.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Record Value Text Field Constraints
        NSLayoutConstraint.activate([
            recordValueTextField.topAnchor.constraint(equalTo: recordTypePicker.bottomAnchor, constant: 16),
            recordValueTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recordValueTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recordValueTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Comments Text Field Constraints
        NSLayoutConstraint.activate([
            commentsTextField.topAnchor.constraint(equalTo: recordValueTextField.bottomAnchor, constant: 16),
            commentsTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentsTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentsTextField.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Placeholder Label Constraints
        NSLayoutConstraint.activate([
            commentsPlaceholderLabel.topAnchor.constraint(equalTo: commentsTextField.topAnchor, constant: 8),
            commentsPlaceholderLabel.leadingAnchor.constraint(equalTo: commentsTextField.leadingAnchor, constant: 8)
        ])
        
        // Save Button Constraints
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: commentsTextField.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        commentsPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
