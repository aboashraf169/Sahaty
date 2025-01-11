//
//  LoginModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct LoginModel: Codable {
    let email: String
    let password: String
    let usersType: UsersType
}

// MARK: - API Request Body
extension LoginModel {
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "password": password,
            "is_doctor": usersType == .doctor ? 1 : 0
        ]
    }
}
