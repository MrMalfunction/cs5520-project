import UIKit

class IPViewMedicalRecordsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Data for the records
    var medicalRecords: [MedicalRecord] = []
    var patientId: String?
    var patientName: String? // The patient name to be passed
    let hospitalName = UserDefaults.standard.string(forKey: "username")

    // View
    private var ipviewMedicalRecordsView: IPViewMedicalRecordsView!
    
    // FirestoreHelper instance
    private let firestoreHelper = FirestoreGenericHelpers()
    
    override func loadView() {
        ipviewMedicalRecordsView = IPViewMedicalRecordsView()
        self.view = ipviewMedicalRecordsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        // Set table view delegate and data source
        ipviewMedicalRecordsView.tableView.delegate = self
        ipviewMedicalRecordsView.tableView.dataSource = self
        setupActions()
        // Fetch medical records
        fetchMedicalRecords(patientId: patientId)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    private func setupActions() {
        ipviewMedicalRecordsView.grantApprovalButton.addTarget(self, action: #selector(onGrantApprovalButtonTapped), for: .touchUpInside)
        ipviewMedicalRecordsView.patientDetailsButton.addTarget(self, action: #selector(PatientDetailsButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Grant Approval Button Action
    @objc private func onGrantApprovalButtonTapped() {
        let grantApprovalController = IGrantApprovalController()
        grantApprovalController.patientId = patientId
        navigationController?.pushViewController(grantApprovalController, animated: true)
    }
    
    @objc private func PatientDetailsButtonTapped() {
        let patientDetailsController = PatientProfileDetailsController()
        patientDetailsController.patientId = patientId
        navigationController?.pushViewController(patientDetailsController, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("this is happening")
        fetchMedicalRecords(patientId: patientId) // Refresh data whenever the view reappears
    }
    


    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IPMedicalRecordCell", for: indexPath) as! IPRecordTableViewCell
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
                    self?.ipviewMedicalRecordsView.tableView.reloadData()
                    self?.showNoDataAlert() // Show an alert if no records are found
                } else {
                    self?.medicalRecords = records
                    self?.ipviewMedicalRecordsView.tableView.reloadData()
                }
            case .failure(let error):
                self?.showErrorAlert(error: error) // Show the error alert if fetching fails
            }
        }
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
        let modalView = IPRecordDetailModalView()
        modalView.configure(with: record)
        modalView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        modalView.center = view.center
        view.addSubview(modalView)
    }
}
