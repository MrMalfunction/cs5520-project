//
//  ProvideHospitalAccessController.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/4/24.
//

import UIKit

class ProvideHospitalAccessController: UIViewController {
    
    // Reference to the custom view
    private var provideHospitalAccessView: ProvideHospitalAccessView!
    
    // Data source for the table view
    private var items: [String] = []
    
    // Firestore helpers
    private let firestoreHelpers = FirestoreGenericHelpers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and configure the view
        provideHospitalAccessView = ProvideHospitalAccessView(frame: view.bounds)
        provideHospitalAccessView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(provideHospitalAccessView)
        
        // Set the table view's data source and delegate
        provideHospitalAccessView.tableView.dataSource = self
        provideHospitalAccessView.tableView.delegate = self
        
        // Set the navigation title
        self.title = "Provide Hospital Access"
        
        // Fetch data from Firestore
        fetchHospitals()
    }
    
    // Fetch hospitals using FirestoreGenericHelpers
    private func fetchHospitals() {
        firestoreHelpers.fetchAvailableHospitalNames { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let hospitalNames):
                    if hospitalNames.isEmpty {
                        self.showAlert(message: "No hospitals available for you at the moment.")
                    } else {
                        self.items = hospitalNames
                        self.provideHospitalAccessView.tableView.reloadData()
                    }
                case .failure(let error):
                    self.showAlert(message: "Failed to fetch hospitals: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Show an alert message
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // Action to be called when "+" button is tapped
    private func addHospital(at indexPath: IndexPath) {
        let hospital = items[indexPath.row]
        print("Adding hospital access for \(hospital)")
        
        // Call the addHospital function from FirestoreGenericHelpers
        firestoreHelpers.addHospital(hospitalName: hospital) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success():
                    // Remove the hospital from the data source
                    self.items.remove(at: indexPath.row)
                    
                    // Update the table view
                    self.provideHospitalAccessView.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    // Show success alert
                    self.showAlert(message: "Successfully added access for \(hospital).")
                case .failure(let error):
                    // Show failure alert
                    self.showAlert(message: "Failed to add access for \(hospital): \(error.localizedDescription)")
                }
            }
        }
    }

}

extension ProvideHospitalAccessController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        // Add the "+" button to the cell
        provideHospitalAccessView.addAddButton(to: cell, at: indexPath) { [weak self] indexPath in
            self?.addHospital(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
