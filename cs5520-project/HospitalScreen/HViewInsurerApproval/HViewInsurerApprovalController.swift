
import UIKit

class HViewInsurerApprovalController: UIViewController {

    // MARK: - Properties
    private let happrovalView = HViewInsurerApprovalView()
    private var approvalRequests: [ApprovalRequest] = [] // Example data model

    var patientId: String?
    
    private let firestoreHelper = FirestoreGenericHelpers()

    override func loadView() {
        view = happrovalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Grant Approval"
        setupDelegates()
        getApprovalRequestsHospital(patientId: patientId!)
    }

    private func setupDelegates() {
        happrovalView.tableView.delegate = self
        happrovalView.tableView.dataSource = self
    }

    private func getApprovalRequestsHospital(patientId: String) {
        // Clear the existing array to avoid duplicates
        approvalRequests.removeAll()
        //let patientId = userData[.uid]
        let hospitalName = UserDefaults.standard.string(forKey: "username")!
        print(" patient id is \(patientId)")
        
        // Call the Firestore fetch function
        firestoreHelper.fetchApproveRequestsHospital(hospitalName: hospitalName, patientId: patientId) { [weak self] result in
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
                    self?.happrovalView.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching approval requests: \(error.localizedDescription)")
            }
        }
    }



}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HViewInsurerApprovalController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvalRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HApprovalCell", for: indexPath) as? HGrantApprovalTableViewCell else {
            return UITableViewCell()
        }

        let request = approvalRequests[indexPath.row]
        cell.patientLabel.text = "Patient: \(request.patient)"
        cell.hospitalLabel.text = "Hospital: \(request.hospital)"
        cell.commentLabel.text = "Comment: \(request.comment)"
        cell.statusLabel.text = "Status: \(request.status)"
        return cell
    }

}

