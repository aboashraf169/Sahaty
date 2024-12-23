//
//  UserModel.swift
//  Sahaty
//
//  Created by mido mj on 12/23/24.
//

import Foundation


struct UserModel: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var fullName: String
    var email: String
    var profilePicture: String?
    var age: Int?
    var gender: Gender?
    var userType: UserType
}
