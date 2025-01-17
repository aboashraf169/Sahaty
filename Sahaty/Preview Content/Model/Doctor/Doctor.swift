//
//  Doctor.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation

struct DoctorModel: Identifiable, Codable {
    var id: Int // معرف الدكتور
    var name: String // اسم الدكتور
    var email: String // البريد الإلكتروني
    var isDoctor: Int // هل هو دكتور
    var jobSpecialtyNumber: Int // رقم التخصص المهني
    var bio: String? // السيرة الذاتية
    var specialties: [Specialty] // قائمة التخصصات
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case isDoctor = "is_doctor"
        case jobSpecialtyNumber = "jop_specialty_number"
        case bio
        case specialties = "specialty"
    }
}

struct Specialty: Identifiable, Codable {
    var id: Int // معرف التخصص
    var name: String // اسم التخصص
    var description: String // وصف التخصص
}
