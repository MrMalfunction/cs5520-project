import UIKit

class ViewMedicalRecordsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Data for the records
    var medicalRecords: [MedicalRecord] = []

    // View
    private var viewMedicalRecordsView: ViewMedicalRecordsView!
    
    // FirestoreHelper instance
    private let firestoreHelper = FirestoreGenericHelpers()
    
    override func loadView() {
        viewMedicalRecordsView = ViewMedicalRecordsView()
        self.view = viewMedicalRecordsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table view delegate and data source
        viewMedicalRecordsView.tableView.delegate = self
        viewMedicalRecordsView.tableView.dataSource = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        // Fetch medical records
        fetchMedicalRecords()
    }

    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalRecordCell", for: indexPath) as! RecordTableViewCell
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
    func fetchMedicalRecords() {
        firestoreHelper.fetchMedicalRecordsForPatient { [weak self] result in
            switch result {
            case .success(let records):
                // If there are records, display them in the table
                if records.isEmpty {
                    self?.showNoDataAlert() // Show an alert if no records are found
                } else {
                    self?.medicalRecords = records
                    self?.viewMedicalRecordsView.tableView.reloadData()
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
        let modalView = RecordDetailModalView()
        modalView.configure(with: record)
        modalView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        modalView.center = view.center
        view.addSubview(modalView)
    }
}
