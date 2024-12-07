
import UIKit

class HPViewMedicalRecordsView: UIView {

    // MARK: - UI Elements
    let tableView = UITableView()
    let addRecordButton = UIButton(type: .system) // Add Medical Record Button
    let requestApprovalButton = UIButton(type: .system) // Request Insurer Approval Button
    let showPatientDetailsButton = UIButton(type: .system)
    let viewPreviousRequestsButton = UIButton(type: .system)

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
        
        showPatientDetailsButton.setTitle("Patient's Details", for: .normal)
        showPatientDetailsButton.setTitleColor(.white, for: .normal)
        showPatientDetailsButton.backgroundColor = .systemBlue
        showPatientDetailsButton.layer.cornerRadius = 8
        showPatientDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showPatientDetailsButton)
        
        viewPreviousRequestsButton.setTitle("Show Previous Requests", for: .normal)
        viewPreviousRequestsButton.setTitleColor(.white, for: .normal)
        viewPreviousRequestsButton.backgroundColor = .systemGreen
        viewPreviousRequestsButton.layer.cornerRadius = 8
        viewPreviousRequestsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewPreviousRequestsButton)

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
            addRecordButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -16), // Shorten the width by increasing spacing

            addRecordButton.heightAnchor.constraint(equalToConstant: 44),

            // Request Approval Button
            requestApprovalButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            requestApprovalButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 1), // Narrow spacing to widen the button
            requestApprovalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), // Increase width by reducing trailing spacing
            requestApprovalButton.heightAnchor.constraint(equalToConstant: 44),
            
            showPatientDetailsButton.topAnchor.constraint(equalTo: requestApprovalButton.topAnchor, constant: 54),
            showPatientDetailsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showPatientDetailsButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -16), // Shorten the width by increasing spacing
            showPatientDetailsButton.heightAnchor.constraint(equalToConstant: 44),

            // Request Approval Button
            viewPreviousRequestsButton.topAnchor.constraint(equalTo: requestApprovalButton.topAnchor, constant: 54),
            viewPreviousRequestsButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 1), // Narrow spacing to widen the button
            viewPreviousRequestsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), // Increase width by reducing trailing spacing
            viewPreviousRequestsButton.heightAnchor.constraint(equalToConstant: 44),

            // TableView
            tableView.topAnchor.constraint(equalTo: viewPreviousRequestsButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
