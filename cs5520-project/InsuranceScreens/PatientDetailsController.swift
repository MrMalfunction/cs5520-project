//
//  PatientDetailsController.swift .swift
//  cs5520-project
//
//  Created by Ishan Aggarwal on 28/11/24.
//

import Foundation
import UIKit

class PatientDetailsController: UIViewController {

    // MARK: - Properties
    var patientDetails: (id: String, name: String)? {
        didSet {
            configureDetails()
        }
    }

    // MARK: - UI Elements
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill") // Placeholder profile icon
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 // Circular shape
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let dobLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let hospitalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        title = "Patient Details"
        view.addSubview(profileImageView)
        view.addSubview(stackView)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(dobLabel)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(hospitalLabel)

        NSLayoutConstraint.activate([
            // Profile Image Constraints
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            // Stack View Constraints
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Configure Details
    private func configureDetails() {
        guard let patientDetails = patientDetails else { return }

        nameLabel.text = "Name: \(patientDetails.name)"
        idLabel.text = "ID: \(patientDetails.id)"
        dobLabel.text = "DOB: 01/01/1990" // Example; replace with actual DOB
        ageLabel.text = "Age: 33"         // Example; replace with calculated or actual age
        hospitalLabel.text = "Hospital: General Hospital" // Example; replace with actual hospital name
    }
}
