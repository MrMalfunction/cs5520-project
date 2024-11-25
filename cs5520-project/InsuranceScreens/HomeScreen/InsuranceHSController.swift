//
//  InsuranceHSController.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/25/24.
//

import UIKit

class InsuranceHSController: UIViewController {

    // MARK: - Properties
    private let customView = InsuranceHSView() // Replace with your custom UIView class

    // MARK: - Lifecycle Methods
    override func loadView() {
        // Assign the custom view to the controller's view
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Add target-action or delegate bindings here
        // Example: customView.someButton.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
    }
}
