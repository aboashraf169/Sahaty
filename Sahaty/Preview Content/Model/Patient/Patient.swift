//
//  Patient.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation

struct PatientModel: Identifiable {
    var id = UUID() // معرف فريد للمريض
    var fullName: String // الاسم الكامل
    var email: String // البريد الإلكتروني
    var profilePicture: String? // رابط الصورة الشخصية (اختياري)
    var age: Int? // العمر (اختياري)
    var gender: String? // الجنس (اختياري)
    var medicalHistory: String? // السجل الطبي (اختياري)
    
    // العلاقات
    var followedDoctors: [DoctorModel] // قائمة الأطباء المتابعين
    var favoriteArticles: [ArticalModel] // قائمة المقالات المفضلة
    var favoriteAdvices: [AdviceModel] // قائمة النصائح المفضلة
    var likedArticles: [ArticalModel] // قائمة المقالات التي أعجب بها المريض
    var articleComments: [CommentModel] // قائمة التعليقات المرتبطة بالمقالات
}

