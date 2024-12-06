import UIKit

class PatientHSView: UIView {

    // MARK: - UI Elements
    let titleLabel = UILabel()
    let addMedicalRecordButton = UIButton(type: .system)
    let viewMedicalRecordButton = UIButton(type: .system)
    let provideAccessButton = UIButton(type: .system)
    let reviewAccessButton = UIButton(type: .system)
    
    // ScrollView and ContentView
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor.systemBackground
        
        // Add ScrollView to the main view
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        titleLabel.text = "Patient Home Screen"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        // Setup the buttons with style
        setupButton(button: addMedicalRecordButton, title: "Add Medical Records")
        setupButton(button: viewMedicalRecordButton, title: "See Medical Records")
        setupButton(button: provideAccessButton, title: "Provide Hospital Access")
        setupButton(button: reviewAccessButton, title: "Review Hospital Access")
    }

    private func setupButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14) // Add padding inside buttons
        contentView.addSubview(button)
    }

    private func setupConstraints() {
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addMedicalRecordButton.translatesAutoresizingMaskIntoConstraints = false
        viewMedicalRecordButton.translatesAutoresizingMaskIntoConstraints = false
        provideAccessButton.translatesAutoresizingMaskIntoConstraints = false
        reviewAccessButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Add Medical Record Button
            addMedicalRecordButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            addMedicalRecordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addMedicalRecordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addMedicalRecordButton.heightAnchor.constraint(equalToConstant: 60),
                        
            // View Medical Record Button
            viewMedicalRecordButton.topAnchor.constraint(equalTo: addMedicalRecordButton.bottomAnchor, constant: 20),
            viewMedicalRecordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            viewMedicalRecordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            viewMedicalRecordButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Provide Access Button
            provideAccessButton.topAnchor.constraint(equalTo: viewMedicalRecordButton.bottomAnchor, constant: 20),
            provideAccessButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            provideAccessButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            provideAccessButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Review Access Button
            reviewAccessButton.topAnchor.constraint(equalTo: provideAccessButton.bottomAnchor, constant: 20),
            reviewAccessButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reviewAccessButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reviewAccessButton.heightAnchor.constraint(equalToConstant: 60),
            reviewAccessButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
