//
//  ViewMedicalRecordsView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/5/24.
//

import UIKit

class HPViewMedicalRecordsView: UIView {

    // MARK: - UI Elements
    let tableView = UITableView()
    let addRecordButton = UIButton(type: .system) // Add Medical Record Button
    let requestApprovalButton = UIButton(type: .system) // Request Insurer Approval Button

    // MARK: - Initializer
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

    // Setup view components
    private func setupViews() {
        backgroundColor = .white

        // Configure Add Record Button
        addRecordButton.setTitle("Add Medical Record", for: .normal)
        addRecordButton.setTitleColor(.white, for: .normal)
        addRecordButton.backgroundColor = .systemBlue
        addRecordButton.layer.cornerRadius = 8
        addRecordButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addRecordButton)

        // Configure Request Approval Button
        requestApprovalButton.setTitle("Request Insurer's Approval", for: .normal)
        requestApprovalButton.setTitleColor(.white, for: .normal)
        requestApprovalButton.backgroundColor = .systemGreen
        requestApprovalButton.layer.cornerRadius = 8
        requestApprovalButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(requestApprovalButton)

        // Configure the TableView
        tableView.register(HPRecordTableViewCell.self, forCellReuseIdentifier: "HPMedicalRecordCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }

    // Setup constraints for layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Add Record Button
            addRecordButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            addRecordButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addRecordButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -8),
            addRecordButton.heightAnchor.constraint(equalToConstant: 44),

            // Request Approval Button
            requestApprovalButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            requestApprovalButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 8),
            requestApprovalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            requestApprovalButton.heightAnchor.constraint(equalToConstant: 44),

            // TableView
            tableView.topAnchor.constraint(equalTo: addRecordButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
