
import UIKit

class HPAddRecordScreenController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // View
    private var hpaddRecordView: HPAddRecordView!
    var patientId: String? // The patient name to be passed
    
    // Data
    private let recordTypeOptions = ["Blood Glucose Level", "Blood Cholesterol Level", "Blood Pressure", "Other"]
    private var selectedRecordType: String?
    
    private let firestoreHelper = FirestoreGenericHelpers() // Assuming Firestore helper is initialized here
    
    override func loadView() {
        hpaddRecordView = HPAddRecordView()
        self.view = hpaddRecordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Picker DataSource and Delegate
        hpaddRecordView.recordTypePicker.delegate = self
        hpaddRecordView.recordTypePicker.dataSource = self
        
        // Set default selected record type to the first option
        selectedRecordType = recordTypeOptions[0] // Set default value
        hpaddRecordView.recordTypePicker.selectRow(0, inComponent: 0, animated: false) // Select the first row in picker

        // Set up Save Button Action
        hpaddRecordView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    // PickerView Delegate & DataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recordTypeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recordTypeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRecordType = recordTypeOptions[row]
    }
    
    // Save Button Action
    @objc private func saveButtonTapped() {
         guard let selectedRecordType = selectedRecordType else {
             showAlert(title: "Error", message: "Please select a record type.")
             return
         }

         guard let recordValue = hpaddRecordView.recordValueTextField.text, !recordValue.isEmpty else {
             showAlert(title: "Error", message: "Please enter a report value.")
             return
         }

         let comments = hpaddRecordView.commentsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
         let currentHospitalUsername = UserDefaults.standard.string(forKey: "username") ?? "Unknown"

         // Ensure the patientId is set
         guard let patientId = patientId else {
             showAlert(title: "Error", message: "Patient ID is missing.")
             return
         }

         // Call Firestore method to add the medical record
         firestoreHelper.addMedicalRecord(
             recordType: selectedRecordType,
             value: recordValue,
             comments: comments,
             enteredBy: "Hospital \(currentHospitalUsername)",
             patientId: patientId
         ) { result in
             switch result {
             case .success():
                 self.showAlert(title: "Success", message: "Medical record saved successfully.") {
                     // Pop the view controller after success alert is dismissed
                     self.navigationController?.popViewController(animated: true)
                 }
             case .failure(let error):
                 self.showAlert(title: "Error", message: "Failed to save medical record: \(error.localizedDescription)")
             }
         }
     }

    
    // Alert Function with completion handler
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()  // Execute completion block if provided
        })
        present(alert, animated: true)
    }
}
