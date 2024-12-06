//
//  Enums.swift
//  cs5520-project
//
//  Created by Amol Bohora on 11/20/24.
//

enum UserProfileKey: String {
    case email
    case linkedHospitals
    case linkedInsurers
    case name
    case profileImage
    case uid
    case userType
    
    // Define associated value types
    var valueType: Any.Type {
        switch self {
        case .email, .name, .profileImage, .uid, .userType:
            return String.self
        case .linkedHospitals, .linkedInsurers:
            return [String].self
        }
    }
}

struct MedicalRecord {
    let enteredBy: String
    let patientId: String
    let recordType: String
    let timestamp: String
    let value: String
}
