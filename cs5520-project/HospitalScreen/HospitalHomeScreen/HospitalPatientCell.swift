//
//  HospitalPatientCell.swift
//  cs5520-project
//
//  Created by Sumit Pagar on 12/6/24.
//


import UIKit

class HospitalPatientCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let hospitalsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        // Profile Image
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.backgroundColor = .lightGray

        // Name Label
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        // Email Label
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .darkGray

        // Hospitals Label
        hospitalsLabel.font = .systemFont(ofSize: 12)
        hospitalsLabel.textColor = .gray
        hospitalsLabel.numberOfLines = 0

        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(hospitalsLabel)
    }

    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        hospitalsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Profile Image Constraints
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),

            // Name Label Constraints
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Email Label Constraints
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Hospitals Label Constraints
            hospitalsLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            hospitalsLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            hospitalsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            hospitalsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(name: String, email: String, hospitals: String, profileImage: UIImage?) {
        nameLabel.text = "Name: \(name)"
        emailLabel.text = "Email: \(email)"
        hospitalsLabel.text = "Insurer: \(hospitals)"
        profileImageView.image = profileImage ?? UIImage(named: "placeholder") // Default placeholder if no image
    }

}
