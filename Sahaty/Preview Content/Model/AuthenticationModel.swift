//
//  AuthenticationModel.swift
//  Sahaty
//
//  Created by mido mj on 12/6/24.
//

import Foundation

struct AuthenticationModel {
    var fullName : String
    var email: String
    var password: String
    var confirmPassword: String?
    var specialization: String?
    var licenseNumber: String?
    var userType: UserType
}

enum UserType {
    case patient
    case doctor
}



