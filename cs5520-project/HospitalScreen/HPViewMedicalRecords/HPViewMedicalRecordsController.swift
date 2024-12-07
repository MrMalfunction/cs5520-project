import UIKit

class HPViewMedicalRecordsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Data for the records
    var medicalRecords: [MedicalRecord] = []
    var patientId: String?
    var patientName: String? // The patient name to be passed
    var insurerName: String?
    let hospitalName = UserDefaults.standard.string(forKey: "username")

    // View
    private var hpviewMedicalRecordsView: HPViewMedicalRecordsView!
    
    // FirestoreHelper instance
    private let firestoreHelper = FirestoreGenericHelpers()
    
    override func loadView() {
        hpviewMedicalRecordsView = HPViewMedicalRecordsView()
        self.view = hpviewMedicalRecordsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table view delegate and data source
        hpviewMedicalRecordsView.tableView.delegate = self
        hpviewMedicalRecordsView.tableView.dataSource = self
        setupActions()
        // Fetch medical records
        fetchMedicalRecords(patientId: patientId)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("this is happening")
        fetchMedicalRecords(patientId: patientId) // Refresh data whenever the view reappears
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        hpviewMedicalRecordsView.addRecordButton.addTarget(self, action: #selector(onAddRecordTapped), for: .touchUpInside)
        hpviewMedicalRecordsView.requestApprovalButton.addTarget(self, action: #selector(onRequestApprovalTapped), for: .touchUpInside)
        hpviewMedicalRecordsView.showPatientDetailsButton.addTarget(self, action: #selector(onSPDTapped), for: .touchUpInside)
        hpviewMedicalRecordsView.viewPreviousRequestsButton.addTarget(self, action: #selector(onVPRTapped), for: .touchUpInside)
    }
    
    @objc private func onAddRecordTapped() {
        let addRecordVC = HPAddRecordScreenController()
        addRecordVC.patientId = patientId
        navigationController?.pushViewController(addRecordVC, animated: true)
    }
    
    @objc private func onSPDTapped() {
        let patientProfileDetailsVC = PatientProfileDetailsController()
        patientProfileDetailsVC.patientId = patientId
        navigationController?.pushViewController(patientProfileDetailsVC, animated: true)
    }
    
    @objc private func onVPRTapped() {
        let hViewInsurerApprovalController = HViewInsurerApprovalController()
        hViewInsurerApprovalController.patientId = patientId
        navigationController?.pushViewController(hViewInsurerApprovalController, animated: true)
    }

    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HPMedicalRecordCell", for: indexPath) as! HPRecordTableViewCell
        let record = medicalRecords[indexPath.row]
        cell.configure(recordType: record.recordType, subtext: "Added on: \(record.timestamp)")
        return cell
    }

    // TableView Delegate Method (to handle item selection)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecord = medicalRecords[indexPath.row]
        showRecordDetailModal(for: selectedRecord)
    }
    
    // Fetch medical records
    func fetchMedicalRecords(patientId: String? = nil) {
        print("loading medical records")
        firestoreHelper.fetchMedicalRecordsForPatient(patientId: patientId) { [weak self] result in
            switch result {
            case .success(let records):
                // If there are records, display them in the table
                if records.isEmpty {
                    print("records are empty")
                    self?.medicalRecords = []
                    self?.hpviewMedicalRecordsView.tableView.reloadData()
                    self?.showNoDataAlert() // Show an alert if no records are found
                } else {
                    self?.medicalRecords = records
                    self?.hpviewMedicalRecordsView.tableView.reloadData()
                }
            case .failure(let error):
                self?.showErrorAlert(error: error) // Show the error alert if fetching fails
            }
        }
    }
    // MARK: - Request Approval Action
    @objc private func onRequestApprovalTapped() {
        let alertController = UIAlertController(
            title: "Request Insurer's Approval",
            message: "Hospital \(hospitalName ?? "N/A")) needs approval for patient \(patientName ?? "N/A").",
            preferredStyle: .alert
        )

        // Add a text field for comments
        alertController.addTextField { textField in
            textField.placeholder = "Comments"
        }

        // Add OK button
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let comments = alertController.textFields?.first?.text
            // Handle the OK action (send approval request)
            self.saveApproveTapped(comments: comments ?? "")
            
        })

        // Add Cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
    
  

    // MARK: - Utility Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    // Show an alert when no data is found
    private func showNoDataAlert() {
        let alertController = UIAlertController(title: "No Data", message: "No medical records found.", preferredStyle: .alert)
        
        // Add an OK button to the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show the error alert
    private func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        // Add an OK button to the alert
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // After OK is tapped, pop the view controller
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show the modal with record details
    private func showRecordDetailModal(for record: MedicalRecord) {
        let modalView = HPRecordDetailModalView()
        modalView.configure(with: record)
        modalView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        modalView.center = view.center
        view.addSubview(modalView)
    }
    
    
    @objc private func saveApproveTapped(comments: String) {
        let currentHospitalUsername = UserDefaults.standard.string(forKey: "username") ?? "Unknown"
        let currentHospitalId = UserDefaults.standard.string(forKey: "hospitalId") ?? "Unknown"

        guard let patientId = patientId else {
            showAlert(title: "Error", message: "Patient ID is missing.")
            return
        }

        firestoreHelper.addApproveRequest(
            status: "Pending", // Assuming you want to set an initial status
            comments: comments,
            insurerName: insurerName ?? "",
            patientName: patientName ?? "",
            patientId: patientId,
            hospitalName: currentHospitalUsername,
            hospitalId: currentHospitalId
        ) { result in
            switch result {
            case .success():
                self.showAlert(title: "Success", message: "Approval request sent.")
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self.showAlert(title: "Error", message: "Failed to save medical record: \(error.localizedDescription)")
            }
        }
    }
}
