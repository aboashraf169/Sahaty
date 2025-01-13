//
//  SignUpModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {  
    var fullName: String
    var email: String
    var password: String
    var specialization: String?
    var licenseNumber: String?
    var usersType: UsersType
    
}


// MARK: - API Request Body
extension SignUpModel {
    func toDictionary() -> [String: Any] {
        return [
            "name": fullName,
            "email": email,
            "password": password,
            "is_doctor": usersType == .doctor ? 1 : 0
        ]
         
    }
}

