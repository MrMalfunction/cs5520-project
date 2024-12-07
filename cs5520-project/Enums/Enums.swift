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
    case dob
    case gender
    case bloodgroup
    case profileImage
    case uid
    case userType
    
    // Define associated value types
    var valueType: Any.Type {
        switch self {
        case .email, .name, .profileImage, .uid, .userType, .bloodgroup, .dob, .gender:
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
    let comments: String
}


struct ApprovalRequest {
    let patient: String
    let hospital: String
    let comment: String
    var status: String
}
