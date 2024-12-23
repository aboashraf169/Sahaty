//
//  CommentAuthor.swift
//  Sahaty
//
//  Created by mido mj on 12/23/24.
//

import Foundation
enum CommentAuthor : Equatable ,Codable {
    case doctor(DoctorModel) // إذا كان المعلق طبيبًا
    case patient(PatientModel) // إذا كان المعلق مريضًا
    
    static func == (lhs: CommentAuthor, rhs: CommentAuthor) -> Bool {
        switch (lhs, rhs) {
        case let (.doctor(lhsDoctor), .doctor(rhsDoctor)):
            return lhsDoctor.id == rhsDoctor.id // مقارنة باستخدام `id` للطبيب
        case let (.patient(lhsPatient), .patient(rhsPatient)):
            return lhsPatient.id == rhsPatient.id // مقارنة باستخدام `id` للمريض
        default:
            return false // إذا كان النوع مختلفًا، فهما غير متساويين
        }
    }
    var name: String {
        switch self {
        case .doctor(let doctor):
            return doctor.user.fullName
        case .patient(let patient):
            return patient.user.fullName
        }
    }

    var image: String? {
        switch self {
        case .doctor(let doctor):
            return doctor.user.profilePicture
        case .patient(let patient):
            return patient.user.profilePicture
        }
    }
}
