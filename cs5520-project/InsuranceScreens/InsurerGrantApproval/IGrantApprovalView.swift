
import UIKit

class IGrantApprovalView: UIView {

    // MARK: - UI Elements
    let tableView = UITableView()

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

        // Configure the TableView
        tableView.register(IGrantApprovalTableViewCell.self, forCellReuseIdentifier: "ApprovalCell")
        tableView.rowHeight = UITableView.automaticDimension // Auto-sizing for longer comments
        tableView.estimatedRowHeight = 100 // Estimated height for taller cells
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }

    // Setup constraints for layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

class IGrantApprovalTableViewCell: UITableViewCell {
    let patientLabel = UILabel()
    let hospitalLabel = UILabel()
    let commentLabel = UILabel()
    let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        let labels = [patientLabel, hospitalLabel, commentLabel, statusLabel]
        labels.forEach {
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        patientLabel.font = UIFont.boldSystemFont(ofSize: 16)
        hospitalLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.textColor = .darkGray
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .blue

        NSLayoutConstraint.activate([
            patientLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            patientLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            patientLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            hospitalLabel.topAnchor.constraint(equalTo: patientLabel.bottomAnchor, constant: 8),
            hospitalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hospitalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            commentLabel.topAnchor.constraint(equalTo: hospitalLabel.bottomAnchor, constant: 8),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
