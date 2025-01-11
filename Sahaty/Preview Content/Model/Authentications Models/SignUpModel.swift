//
//  SignUpModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {
    let fullName: String
    let email: String
    let password: String
    let confirmPassword: String
    let specialization: String?
    let licenseNumber: String?
    let UsersType: UsersType
}


// MARK: - API Request Body
extension SignUpModel {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": fullName,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "is_doctor": UsersType == .doctor ? 1 : 0
        ]
        
        // Add optional fields if they exist
        if let specialization = specialization {
            dict["specialization"] = specialization
        }
        if let licenseNumber = licenseNumber {
            dict["license_number"] = licenseNumber
        }
        
        return dict
    }
}
