import UIKit
import FirebaseFirestore

class HospitalHSController: UIViewController {

    // MARK: - Properties
    private var hospitalView: HospitalHSView!
    private var patients: [(name: String, email: String, profileImage: String, uid: String, linkedHospitals: [String])] = [] // Data from Firestore
    private var filteredPatients: [(name: String, email: String, profileImage: String, uid: String, linkedHospitals: [String])] = [] // Filtered Data for Search

    private let firestoreHelpers = FirestoreGenericHelpers()

    // MARK: - Lifecycle
    override func loadView() {
        hospitalView = HospitalHSView()
        view = hospitalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupNavigationBar()
        fetchPatients()
    }

    // MARK: - Setup Methods
    private func setupDelegates() {
        hospitalView.searchBar.delegate = self
        hospitalView.tableView.delegate = self
        hospitalView.tableView.dataSource = self
    }

    private func setupNavigationBar() {
       

        // Profile Button (Left)
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(onProfileButtonTapped)
        )
        navigationItem.leftBarButtonItem = profileButton

        // Logout Button (Right)
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(onLogoutButtonTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func onProfileButtonTapped() {
        let profileController = HospitalProfileViewController()
        navigationController?.pushViewController(profileController, animated: true)
    }

    @objc private func onLogoutButtonTapped() {
        // Clear user session and navigate to login
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "userType")
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Data Fetching
    private func fetchPatients() {
        firestoreHelpers.fetchCurrentHopsPatientsDetails { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let patients):
                    if patients.isEmpty {
                        self.showAlert(message: "No patients available at the moment.")
                    } else {
                        self.patients = patients
                        self.filteredPatients = patients // Initialize filtered patients
                        self.hospitalView.tableView.reloadData()
                    }
                case .failure(let error):
                    self.showAlert(message: "Failed to fetch patients: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Utility Methods
    private func decodeBase64ToImage(base64String: String) -> UIImage? {
        if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
           let image = UIImage(data: imageData) {
            return image
        }
        return UIImage(named: "placeholder") // Default placeholder if decoding fails
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension HospitalHSController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPatients = patients
        } else {
            filteredPatients = patients.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        hospitalView.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = searchBar.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return prospectiveText.count <= 32
    }
}

// MARK: - UITableViewDataSource
extension HospitalHSController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPatients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalPatientCell", for: indexPath) as? HospitalPatientCell else {
            return UITableViewCell()
        }

        let patient = filteredPatients[indexPath.row]
        let profileImage = decodeBase64ToImage(base64String: patient.profileImage)
        let linkedHospitalsText = patient.linkedHospitals.joined(separator: ", ") // Combine linked hospitals into a string

        cell.configure(name: patient.name, email: patient.email, hospitals: linkedHospitalsText, profileImage: profileImage)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension HospitalHSController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let patient = filteredPatients[indexPath.row]

        // Example navigation logic (to be implemented as needed)
        let patientDetailsVC = UIViewController()
        patientDetailsVC.title = patient.name
        patientDetailsVC.view.backgroundColor = .white

        let detailsLabel = UILabel()
        detailsLabel.text = "Email: \(patient.email)\nUID: \(patient.uid)"
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        patientDetailsVC.view.addSubview(detailsLabel)
        NSLayoutConstraint.activate([
            detailsLabel.centerXAnchor.constraint(equalTo: patientDetailsVC.view.centerXAnchor),
            detailsLabel.centerYAnchor.constraint(equalTo: patientDetailsVC.view.centerYAnchor)
        ])

        navigationController?.pushViewController(patientDetailsVC, animated: true)
    }
}
