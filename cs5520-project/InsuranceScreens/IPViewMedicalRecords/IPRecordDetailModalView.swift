//
//  RecordDetailModalView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/5/24.
//


import UIKit

class IPRecordDetailModalView: UIView {
    
    // UI Elements for displaying record details
    let titleLabel = UILabel()
    let enteredByLabel = UILabel()
    let patientIdLabel = UILabel()
    let recordTypeLabel = UILabel()
    let timestampLabel = UILabel()
    let valueLabel = UILabel()
    let commentsLabel = UILabel() // New label for comments
    let closeButton = UIButton(type: .system)
    
    // Initialization
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
        layer.cornerRadius = 16  // More rounded corners
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 15  // Softer shadow
        
        // Title Label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Configure Details Labels
        let labels = [enteredByLabel, patientIdLabel, recordTypeLabel, timestampLabel, valueLabel, commentsLabel]
        labels.forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .darkGray
            $0.numberOfLines = 0  // Allow for multiline text if necessary
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // Configure Comments Label
        commentsLabel.textColor = .darkGray
        commentsLabel.numberOfLines = 0 // Allow multiline for comments
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Close Button
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .systemBlue
        closeButton.layer.cornerRadius = 10
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        addSubview(closeButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Entered By Label
            enteredByLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            enteredByLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            enteredByLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Patient ID Label
            patientIdLabel.topAnchor.constraint(equalTo: enteredByLabel.bottomAnchor, constant: 12),
            patientIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            patientIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Record Type Label
            recordTypeLabel.topAnchor.constraint(equalTo: patientIdLabel.bottomAnchor, constant: 12),
            recordTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recordTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Timestamp Label
            timestampLabel.topAnchor.constraint(equalTo: recordTypeLabel.bottomAnchor, constant: 12),
            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Value Label
            valueLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Comments Label Constraints
            commentsLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 12),
            commentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            commentsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Close Button Constraints
            closeButton.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 20),
            closeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 120),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func closeModal() {
        self.removeFromSuperview()
    }
    
    func configure(with record: MedicalRecord) {
        titleLabel.text = "Record Details"
        enteredByLabel.text = "Entered By [Entity Type]: \(record.enteredBy)"
        patientIdLabel.text = "Patient ID: \(record.patientId)"
        recordTypeLabel.text = "Record Type: \(record.recordType)"
        timestampLabel.text = "Added on: \(record.timestamp)"
        valueLabel.text = "Stored Value: \(record.value)"
        commentsLabel.text = "Comments: \(record.comments)" // Display comments
    }
}
