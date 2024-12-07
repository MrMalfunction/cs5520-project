//
//  RecordTableViewCell.swift
//  cs5520-project
//
//  Created by Amol Bohora on 12/5/24.
//

import UIKit

class HPRecordTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    let recordTypeLabel = UILabel()
    let subtextLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Configure the labels
        recordTypeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        recordTypeLabel.textColor = .black
        recordTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(recordTypeLabel)

        subtextLabel.font = UIFont.systemFont(ofSize: 14)
        subtextLabel.textColor = .gray
        subtextLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtextLabel)

        // Set constraints
        NSLayoutConstraint.activate([
            recordTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            recordTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recordTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            subtextLabel.topAnchor.constraint(equalTo: recordTypeLabel.bottomAnchor, constant: 4),
            subtextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subtextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(recordType: String, subtext: String) {
        recordTypeLabel.text = recordType
        subtextLabel.text = subtext
    }
}
