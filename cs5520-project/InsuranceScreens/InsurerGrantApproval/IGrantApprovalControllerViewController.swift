
import UIKit

class IGrantApprovalController: UIViewController {

    // MARK: - Properties
    private let approvalView = IGrantApprovalView()
    var approvalRequests: [ApprovalRequest] = [] // Example data model
    var patientId: String?
    let insurerName = UserDefaults.standard.string(forKey: "username")
    
    private let firestoreHelper = FirestoreGenericHelpers()

    override func loadView() {
        view = approvalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        view.backgroundColor = .white
        title = "Grant Approval"
        setupDelegates()
        getApprovalRequests(insurerName: insurerName ?? "", patientId: patientId ?? "")
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }

    private func setupDelegates() {
        approvalView.tableView.delegate = self
        approvalView.tableView.dataSource = self
    }

    private func getApprovalRequests(insurerName: String, patientId: String) {
        // Clear the existing array to avoid duplicates
        approvalRequests.removeAll()
        
        // Call the Firestore fetch function
        firestoreHelper.fetchApproveRequests(insurerName: insurerName, patientId: patientId) { [weak self] result in
            switch result {
            case .success(let documents):
                // Map Firestore documents to ApprovalRequest objects
                self?.approvalRequests = documents.compactMap { document in
                    let data = document.data()
                    return ApprovalRequest(
                        patient: data["PatientName"] as? String ?? "Unknown",
                        hospital: data["hospitalName"] as? String ?? "Unknown",
                        comment: data["comments"] as? String ?? "",
                        status: data["Status"] as? String ?? "Unknown"
                    )
                }
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self?.approvalView.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching approval requests: \(error.localizedDescription)")
            }
        }
    }


    private func updateRequestStatus(at index: Int, status: String) {
        // Update the status in your data model (and Firestore if needed)
        let request = approvalRequests[index]
        firestoreHelper.updateRequestStatusInFirestore(
                patientName: request.patient,
                hospitalName: request.hospital,
                comments: request.comment,
                newStatus: status
            ) { result in
                switch result {
                case .success:
                    print("Status updated successfully!")
                    // Update the local model and reload the table view
                    self.approvalRequests[index].status = status
                    DispatchQueue.main.async {
                        self.approvalView.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                case .failure(let error):
                    print("Error updating status: \(error.localizedDescription)")
                }
            }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension IGrantApprovalController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvalRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCell", for: indexPath) as? IGrantApprovalTableViewCell else {
            return UITableViewCell()
        }

        let request = approvalRequests[indexPath.row]
        cell.patientLabel.text = "Patient: \(request.patient)"
        cell.hospitalLabel.text = "Hospital: \(request.hospital)"
        cell.commentLabel.text = "Comment: \(request.comment)"
        cell.statusLabel.text = "Status: \(request.status)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let request = approvalRequests[indexPath.row]
        print("requset \(request.status)")
        if request.status == "Approved" || request.status == "Denied"{
            print("entered here")
            self.showAlert(message: "This request is already \(request.status).")
            
        }
        else{
            
            let alert = UIAlertController(title: "Approval Request", message: "Do you want to approve or deny this request?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Approve", style: .default, handler: { _ in
                self.updateRequestStatus(at: indexPath.row, status: "Approved")
            }))
            alert.addAction(UIAlertAction(title: "Deny", style: .destructive, handler: { _ in
                self.updateRequestStatus(at: indexPath.row, status: "Denied")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// Example Data Model

