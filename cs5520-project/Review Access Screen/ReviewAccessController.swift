//
//  ReviewAccessController.swift
//  cs5520-project
//
//  Created by MAD6 on 11/28/24.
//


//import UIKit
//
//class ReviewAccessController: UIViewController {
//    
//    private let reviewAccessView = ReviewAccessView()
//    private let authHelper = AuthHelper()
//    private var hospitals: [[String: Any]] = []
//    
//    override func loadView() {
//        view = reviewAccessView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Review Access"
//        setupTableView()
//        fetchAccessList()
//    }
//    
//    private func setupTableView() {
//        reviewAccessView.tableView.dataSource = self
//        reviewAccessView.tableView.delegate = self
//    }
//
//    private func fetchAccessList() {
//        authHelper.fetchGrantedAccess { [weak self] result in
//            switch result {
//            case .success(let accessList):
//                self?.hospitals = accessList
//                DispatchQueue.main.async {
//                    self?.reviewAccessView.tableView.reloadData()
//                }
//            case .failure(let error):
//                self?.showAlert(message: "Failed to load access list: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func revokeAccess(at index: Int) {
//        let hospital = hospitals[index]
//        guard let requestID = hospital["id"] as? String else { return }
//        
//        authHelper.revokeAccess(requestID: requestID) { [weak self] result in
//            switch result {
//            case .success:
//                self?.hospitals.remove(at: index)
//                DispatchQueue.main.async {
//                    self?.reviewAccessView.tableView.reloadData()
//                }
//            case .failure(let error):
//                self?.showAlert(message: "Failed to revoke access: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension ReviewAccessController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return hospitals.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)
//        let hospital = hospitals[indexPath.row]
//        cell.textLabel?.text = hospital["requestedBy"] as? String
//        cell.accessoryType = .detailButton
//        return cell
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension ReviewAccessController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            revokeAccess(at: indexPath.row)
//        }
//    }
//}


import UIKit

class ReviewAccessController: UIViewController {
    private let reviewAccessView = ReviewAccessView()
    private var hospitals: [[String: Any]] = [] // Data source for hospitals
    private var removedHospitals: [Int] = [] // Tracks removed access

    override func loadView() {
        view = reviewAccessView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Review Access"
        setupTableView()
        fetchHospitals() // Fetch data
        setupActions()
    }

    private func setupTableView() {
        reviewAccessView.tableView.delegate = self
        reviewAccessView.tableView.dataSource = self
        reviewAccessView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HospitalCell")
    }

    private func setupActions() {
        reviewAccessView.saveButton.addTarget(self, action: #selector(onSaveTapped), for: .touchUpInside)
    }

    private func fetchHospitals() {
        AuthHelper().fetchGrantedAccess { result in
            switch result {
            case .success(let hospitals):
                self.hospitals = hospitals
                DispatchQueue.main.async {
                    self.reviewAccessView.tableView.reloadData()
                }
            case .failure(let error):
                self.showAlert(message: "Failed to fetch access: \(error.localizedDescription)")
            }
        }
    }

    @objc private func onSaveTapped() {
        // Save the updated access
        for index in removedHospitals {
            let hospital = hospitals[index]
            if let hospitalId = hospital["requestedBy"] as? String {
                AuthHelper().revokeAccess(hospitalId: hospitalId) { result in
                    switch result {
                    case .success:
                        print("Access revoked for hospital \(hospitalId)")
                    case .failure(let error):
                        self.showAlert(message: "Failed to revoke access: \(error.localizedDescription)")
                    }
                }
            }
        }
        showAlert(message: "Changes saved successfully.")
    }

    private func confirmRevokeAccess(at index: Int) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to revoke access for this hospital?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Revoke", style: .destructive, handler: { _ in
            self.removedHospitals.append(index)
            self.hospitals.remove(at: index)
            self.reviewAccessView.tableView.reloadData()
        }))
        present(alert, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension ReviewAccessController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)
        let hospital = hospitals[indexPath.row]

        // Set hospital name
        cell.textLabel?.text = hospital["requestedBy"] as? String

        // Create delete button
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal) // Use the SF Symbol for trash icon
        deleteButton.tintColor = .red // Set the color to red
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(onDeleteTapped(_:)), for: .touchUpInside)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44) // Ensure the button size is appropriate
        
        cell.accessoryView = deleteButton // Assign the button to the accessory view

        return cell
    }


    @objc private func onDeleteTapped(_ sender: UIButton) {
        let index = sender.tag
        confirmRevokeAccess(at: index)
    }
}

