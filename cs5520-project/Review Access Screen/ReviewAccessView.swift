//
//  ReviewAccessView.swift
//  cs5520-project
//
//  Created by MAD6 on 11/28/24.
//


//import UIKit
//
//class ReviewAccessView: UIView {
//    
//    let tableView = UITableView()
//    let saveButton = UIButton(type: .system)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//
//    private func setupViews() {
//        backgroundColor = .white
//        
//        // TableView Configuration
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HospitalCell")
//        addSubview(tableView)
//        
//        // Save Button Configuration
//        saveButton.setTitle("Save", for: .normal)
//        saveButton.tintColor = .white
//        saveButton.backgroundColor = .systemBlue
//        saveButton.layer.cornerRadius = 8
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(saveButton)
//        
//        // Constraints
//        NSLayoutConstraint.activate([
//            // TableView
//            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),
//            
//            // Save Button
//            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
//            saveButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//}


import UIKit

class ReviewAccessView: UIView {
    let tableView = UITableView()
    let saveButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .white
        
        // Setup TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        // Setup Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(saveButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),
            
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
