import UIKit

class InsuranceHSView: UIView, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Patient Records" // Main title
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Patients"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    private let patientsDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Patients Details", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PatientCell")
        return tableView
    }()

    // MARK: - Data Source
    private var patients: [(id: String, name: String)] = [
        (id: "P001", name: "John Doe"),
        (id: "P002", name: "Jane Smith"),
        (id: "P003", name: "Alice Johnson"),
        (id: "P004", name: "Robert Brown")
    ]

    private var filteredPatients: [(id: String, name: String)] = []

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        filteredPatients = patients // Initialize filtered patients
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        filteredPatients = patients // Initialize filtered patients
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(patientsDetailsButton)
        addSubview(tableView)

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        patientsDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Search bar constraints
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Patients Details button constraints
            patientsDetailsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            patientsDetailsButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            patientsDetailsButton.widthAnchor.constraint(equalToConstant: 200),
            patientsDetailsButton.heightAnchor.constraint(equalToConstant: 50),

            // Table view constraints
            tableView.topAnchor.constraint(equalTo: patientsDetailsButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPatients = patients
        } else {
            filteredPatients = patients.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Limit input to 32 characters
        let currentText = searchBar.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return prospectiveText.count <= 32
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPatients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath)
        let patient = filteredPatients[indexPath.row]
        cell.textLabel?.text = "ID: \(patient.id) | Name: \(patient.name)"
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let patient = filteredPatients[indexPath.row]
        
        // Pass patient details to PatientDetailsController
        let patientDetailsVC = PatientDetailsController()
        patientDetailsVC.patientDetails = patient
        if let viewController = self.window?.rootViewController as? UINavigationController {
            viewController.pushViewController(patientDetailsVC, animated: true)
        }
    }

    
}
