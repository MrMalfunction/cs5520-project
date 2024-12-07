//
//  ViewInsurerApprovalController.swift
//  cs5520-project
//
//  Created by Sumit Pagar on 12/7/24.
//

import UIKit

class ViewInsurerApprovalController: UIViewController {

    // MARK: - Properties
    private let approvalView = ViewInsurerApprovalView()
    private var approvalRequests: [ApprovalRequest] = [] // Example data model

    let insurerName = UserDefaults.standard.string(forKey: "username")
    
    private let firestoreHelper = FirestoreGenericHelpers()

    override func loadView() {
        view = approvalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Grant Approval"
        setupDelegates()
        getApprovalRequestsPatient()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }

    private func setupDelegates() {
        approvalView.tableView.delegate = self
        approvalView.tableView.dataSource = self
    }

    private func getApprovalRequestsPatient() {
        // Clear the existing array to avoid duplicates
        approvalRequests.removeAll()
        //let patientId = userData[.uid]
        let patientId = UserDefaults.standard.string(forKey: "uid")
        print(" patient id is \(patientId)")
        
        // Call the Firestore fetch function
        firestoreHelper.fetchApproveRequestsPatient(patientId: patientId!) { [weak self] result in
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



}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewInsurerApprovalController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvalRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PApprovalCell", for: indexPath) as? PGrantApprovalTableViewCell else {
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

