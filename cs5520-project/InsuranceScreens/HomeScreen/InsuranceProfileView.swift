import UIKit

class InsuranceProfileView: UIView {

    private let medicalIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cross.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Insurance Agent:"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private let nameValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private let emailValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(medicalIcon)
        medicalIcon.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameValueLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(emailValueLabel)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            medicalIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            medicalIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            medicalIcon.widthAnchor.constraint(equalToConstant: 80),
            medicalIcon.heightAnchor.constraint(equalToConstant: 80),

            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: medicalIcon.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    func updateProfile(name: String, email: String) {
        nameValueLabel.text = name
        emailValueLabel.text = email
    }
}
