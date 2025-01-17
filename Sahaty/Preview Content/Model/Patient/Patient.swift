//
//  Patient.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation
struct PatiantModel: Identifiable, Codable {
    var id: Int // معرف المريض من السيرفر
    var fullName: String
    var email: String
    var profilePicture: String?
    var age: Int?
    var gender: String?
    var medicalHistory: String?
    var followedDoctors: [DoctorModel]? // الأطباء المتابعين
}
