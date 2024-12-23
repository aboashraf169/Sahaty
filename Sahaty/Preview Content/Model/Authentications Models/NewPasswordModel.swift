//
//  NewPasswordModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct NewPasswordModel:  Identifiable, Codable, Equatable  {
    var password: String
    var confirmPassword: String?
}
