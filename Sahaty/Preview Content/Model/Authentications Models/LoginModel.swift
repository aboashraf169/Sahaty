//
//  LoginModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

struct LoginModel: Identifiable, Codable, Equatable  {
    var email: String
    var password: String
    var userType: UserType
}

