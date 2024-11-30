//
//  PatientHSView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/25/24.
//

import UIKit

class PatientHSView: UIView {

    // MARK: - UI Elements
    let titleLabel = UILabel()
    let addMedicalRecordButton = UIButton(type: .system)
    let provideAccessButton = UIButton(type: .system)
    let reviewAccessButton = UIButton(type: .system)
    let userPhotoButton = UIButton(type: .custom)


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
        backgroundColor = UIColor.systemBackground
        
        // Title Label
        titleLabel.text = "Patient Home Screen"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        addSubview(titleLabel)
        
        // Setup the buttons with style
        setupButton(button: addMedicalRecordButton, title: "Add Medical Records")
        setupButton(button: provideAccessButton, title: "Provide Access")
        setupButton(button: reviewAccessButton, title: "Review Access")
        
        // User Photo Button
        userPhotoButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        userPhotoButton.tintColor = .systemBlue
        userPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(userPhotoButton)
    }

    private func setupButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14) // Add padding inside buttons
        addSubview(button)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addMedicalRecordButton.translatesAutoresizingMaskIntoConstraints = false
        provideAccessButton.translatesAutoresizingMaskIntoConstraints = false
        reviewAccessButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Add Medical Record Button
            addMedicalRecordButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            addMedicalRecordButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addMedicalRecordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addMedicalRecordButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Provide Access Button
            provideAccessButton.topAnchor.constraint(equalTo: addMedicalRecordButton.bottomAnchor, constant: 20),
            provideAccessButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            provideAccessButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            provideAccessButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Review Access Button
            reviewAccessButton.topAnchor.constraint(equalTo: provideAccessButton.bottomAnchor, constant: 20),
            reviewAccessButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            reviewAccessButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            reviewAccessButton.heightAnchor.constraint(equalToConstant: 60),
            
            userPhotoButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            userPhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userPhotoButton.widthAnchor.constraint(equalToConstant: 40),
            userPhotoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
