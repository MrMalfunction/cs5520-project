import UIKit

class ReviewHospitalAccessView: UIView {
    
    // Table view property
    let tableView = UITableView()
    
    // Initialize the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    // Setup TableView
    private func setupTableView() {
        // Add the table view to the view hierarchy
        tableView.frame = bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(tableView)
        
        // Set the table view's data source and delegate (to be set by controller)
        tableView.dataSource = nil // Will be set in the ViewController
        tableView.delegate = nil // Will be set in the ViewController
        
        // Register a basic UITableViewCell class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Method to create and add the X button to the cell with a closure for action
    func addDeleteButton(to cell: UITableViewCell, at indexPath: IndexPath, action: @escaping (IndexPath) -> Void) {
        let deleteButton = UIButton(type: .system)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.addAction(UIAction(handler: { _ in
            action(indexPath) // Call the closure with the indexPath
        }), for: .touchUpInside)
        cell.accessoryView = deleteButton
    }
}
