//
//  OtpVerificationModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct OtpVerificationModel: Codable {
    let email: String
    let otpCode: String
}

// MARK: - API Request Body
extension OtpVerificationModel {
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "otp_code": otpCode
        ]
    }
}
