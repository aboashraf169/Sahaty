//
//  Comment.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//


import Foundation


struct  CommentModel: Identifiable {
    let id = UUID() // معرف فريد للتعليق
    var text: String // نص التعليق
    var author: CommentAuthor // المعلق (طبيب أو مريض)
    var publishDate: Date // تاريخ نشر التعليق
    var likeCount: Int = 0
    var CommentCount: Int = 0
}


enum CommentAuthor : Equatable {
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
            return doctor.fullName
        case .patient(let patient):
            return patient.fullName
        }
    }

    var image: String? {
        switch self {
        case .doctor(let doctor):
            return doctor.profilePicture
        case .patient(let patient):
            return patient.profilePicture
        }
    }
}
