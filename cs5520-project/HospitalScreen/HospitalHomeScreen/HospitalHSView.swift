//
//  HospitalHSView.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/25/24.
//

import UIKit

class HospitalHSView: UIView, UISearchBarDelegate, UITableViewDelegate{


    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hospital's Patient Records" // Main title
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Patient"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

//    let hospitalDetailsButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Hospital Details", for: .normal)
//        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .black
//        button.layer.cornerRadius = 8
//        return button
//    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HospitalCell")
        return tableView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup Methods
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(searchBar)
        //addSubview(hospitalDetailsButton)
        addSubview(tableView)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //hospitalDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Search bar constraints
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            // Hospital Details button constraints
//            hospitalDetailsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            hospitalDetailsButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
//            hospitalDetailsButton.widthAnchor.constraint(equalToConstant: 200),
//            hospitalDetailsButton.heightAnchor.constraint(equalToConstant: 50),

            // Table view constraints
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

