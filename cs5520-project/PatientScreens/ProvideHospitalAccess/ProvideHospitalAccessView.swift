//
//  ProvideHospitalAccessView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/4/24.
//

import UIKit

class ProvideHospitalAccessView: UIView {
    
    // Table view to display the list
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Configure the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Method to add a "+" button to a cell
    func addAddButton(to cell: UITableViewCell, at indexPath: IndexPath, action: @escaping (IndexPath) -> Void) {
        let addButton = UIButton(type: .system)
        addButton.setTitle("+", for: .normal)
        addButton.addTargetClosure { _ in action(indexPath) }
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(addButton)
        
        // Constraints for the button
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
    }
}

// UIButton extension to handle closures
extension UIButton {
    private struct AssociatedKeys {
        static var actionKey = "actionKey"
    }
    
    private var action: ((IndexPath) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? ((IndexPath) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(action: @escaping (IndexPath) -> Void) {
        self.action = action
        self.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
    }
    
    @objc private func executeAction() {
        if let action = action {
            action(IndexPath(row: 0, section: 0)) // Dummy index path for extension (real logic in controller)
        }
    }
}
