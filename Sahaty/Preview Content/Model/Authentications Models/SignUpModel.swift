//
//  SignUpModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct SignUpModel {
    var fullName: String
    var email: String
    var password: String
    var confirmPassword: String
    var specialization: String?
    var licenseNumber: String?
    var userType: UserType
}
