//
//  ResetPasswordModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct ResetPasswordModel {
    var email: String
    var otpCode: String?
    var newPassword: String?
    var confirmPassword: String?
}
