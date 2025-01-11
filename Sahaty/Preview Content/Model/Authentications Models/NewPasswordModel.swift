//
//  NewPasswordModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct NewPasswordModel: Codable {
    let password: String
    let confirmPassword: String?
    let oldPassword: String?
}

// MARK: - API Request Body
extension NewPasswordModel {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["password": password]
        
        if let confirmPassword = confirmPassword {
            dict["password_confirmation"] = confirmPassword
        }
        if let oldPassword = oldPassword {
            dict["old_password"] = oldPassword
        }
        
        return dict
    }
}
