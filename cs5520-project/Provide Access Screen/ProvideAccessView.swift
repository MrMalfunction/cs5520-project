//
//  ProvideAccessView.swift
//  cs5520-project
//
//  Created by MAD6 on 11/26/24.
//


import UIKit

class ProvideAccessView: UIView {
    
    // UI Elements
    let hospitalCodeField = UITextField()
    let approveButton = UIButton(type: .system)
    
    // Init method
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
        
        // Set up Hospital Code text field
        hospitalCodeField.placeholder = "Hospital Code"
        hospitalCodeField.borderStyle = .roundedRect
        hospitalCodeField.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up Approve button
        approveButton.setTitle("Approve", for: .normal)
        approveButton.tintColor = .white
        approveButton.backgroundColor = .systemBlue
        approveButton.layer.cornerRadius = 8
        approveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add UI components to the view
        addSubview(hospitalCodeField)
        addSubview(approveButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Hospital Code Field - Centered horizontally and vertically
            hospitalCodeField.centerXAnchor.constraint(equalTo: centerXAnchor),
            hospitalCodeField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            hospitalCodeField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hospitalCodeField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hospitalCodeField.heightAnchor.constraint(equalToConstant: 44),
            
            // Approve Button - Centered below the text field
            approveButton.topAnchor.constraint(equalTo: hospitalCodeField.bottomAnchor, constant: 60),
            approveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            approveButton.heightAnchor.constraint(equalToConstant: 50),
            approveButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
