import UIKit

class ReviewHospitalAccessController: UIViewController {
    
    // Reference to the custom view
    var provideHospitalAccessView: ReviewHospitalAccessView!
    private let authHelper = AuthHelper()
    private let firestoreHelper = FirestoreGenericHelpers()
    
    // Data for the table view (start empty)
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the view and add it to the controller's view hierarchy
        provideHospitalAccessView = ReviewHospitalAccessView(frame: view.bounds)
        provideHospitalAccessView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(provideHospitalAccessView)
        
        // Set the table view's data source and delegate
        provideHospitalAccessView.tableView.dataSource = self
        provideHospitalAccessView.tableView.delegate = self
        
        // Set the title of the view controller
        self.title = "Hospital Access"
        
        // Load data
        loadData()
    }
    
    // Action to be called when the "X" button is clicked
    func deleteHospital(at indexPath: IndexPath) {
        let hospitalToDelete = self.items[indexPath.row]
        print("DELETE CALLED ON \(hospitalToDelete)")
        
        self.firestoreHelper.removeHospitalFromUser(hospital: hospitalToDelete) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.items.remove(at: indexPath.row)
                    self?.provideHospitalAccessView.tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    self?.showAlert(message: "Failed to remove hospital: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Load data from authHelper and reload the table view
    func loadData() {
        // Optionally show a loading spinner
        provideHospitalAccessView.tableView.reloadData()
        
        authHelper.fetchUserData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    if let linkedHospitals = userData[.linkedHospitals] as? [String], !linkedHospitals.isEmpty {
                        print("Setting Hospitals: \(linkedHospitals)")
                        self.items = linkedHospitals
                    } else {
                        print("No Hospitals Linked")
                        self.items = []
                        self.showAlert(message: "No Hospitals Linked Yet")
                    }
                case .failure(let error):
                    self.showAlert(message: "Failed to load user data: \(error.localizedDescription)")
                }
                
                // Reload the table view after data is fetched
                self.provideHospitalAccessView.tableView.reloadData()
            }
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true, completion: nil)
    }
}

extension ReviewHospitalAccessController: UITableViewDataSource, UITableViewDelegate {
    
    // Number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // Configure the cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        // Add the X button to the cell for the delete action
        provideHospitalAccessView.addDeleteButton(to: cell, at: indexPath) { [weak self] indexPath in
            self?.deleteHospital(at: indexPath)
        }
        
        return cell
    }
    
    // Optional: Handle deletion of a row through swipe actions (this isn't required if you're only using the button)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Perform the deletion action (e.g., remove the item)
            items.remove(at: indexPath.row)
            
            // Animate the deletion in the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
