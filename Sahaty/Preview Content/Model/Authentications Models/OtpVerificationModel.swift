//
//  OtpVerificationModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct OtpVerificationModel :  Identifiable, Codable, Equatable {
    var email: String
    var otpCode: String
}
