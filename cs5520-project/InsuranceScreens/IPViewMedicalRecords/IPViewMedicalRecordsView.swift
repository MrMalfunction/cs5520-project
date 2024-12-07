
import UIKit

class IPViewMedicalRecordsView: UIView {

    // MARK: - UI Elements
    let tableView = UITableView()
    let grantApprovalButton = UIButton(type: .system)
    let patientDetailsButton = UIButton(type: .system)

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

    // MARK: - Setup View Components
    private func setupViews() {
        backgroundColor = .white

        // Configure Grant Approval Button
        configureButton(grantApprovalButton, title: "Grant Approval", color: .systemBlue)

        // Configure Patient's Details Button
        configureButton(patientDetailsButton, title: "Patient's Details", color: .systemGreen)

        // Configure the TableView
        tableView.register(IPRecordTableViewCell.self, forCellReuseIdentifier: "IPMedicalRecordCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }

    // MARK: - Configure Buttons
    private func configureButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Patient's Details Button
            patientDetailsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            patientDetailsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            patientDetailsButton.trailingAnchor.constraint(equalTo: grantApprovalButton.leadingAnchor, constant: -8),
            patientDetailsButton.heightAnchor.constraint(equalToConstant: 44),
            patientDetailsButton.widthAnchor.constraint(equalTo: grantApprovalButton.widthAnchor),

            // Grant Approval Button
            grantApprovalButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            grantApprovalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            grantApprovalButton.heightAnchor.constraint(equalToConstant: 44),

            // TableView
            tableView.topAnchor.constraint(equalTo: grantApprovalButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

