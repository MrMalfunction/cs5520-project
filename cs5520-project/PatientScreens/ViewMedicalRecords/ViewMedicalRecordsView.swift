
import UIKit

class ViewMedicalRecordsView: UIView {

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
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "MedicalRecordCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }

    // Setup constraints for layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
