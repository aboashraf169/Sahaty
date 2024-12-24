//
//  Doctor.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation

struct DoctorModel: Identifiable {
    
    
    var id = UUID() // معرف فريد للطبيب
    var fullName: String // الاسم الكامل
    var email: String // البريد الإلكتروني
    var specialization: String // التخصص
    var licenseNumber: String // رقم الترخيص
    var profilePicture: String? // رابط الصورة الشخصية (اختياري)
    var biography: String? // السيرة الذاتية (اختياري)
    var articlesCount: Int // عدد المقالات المنشورة
    var advicesCount: Int // عدد النصائح
    var followersCount: Int // عدد المتابعين
    
    
    
    // العلاقات
    var articles: [ArticalModel] // قائمة المقالات التي نشرها
    var advices: [AdviceModel] // قائمة النصائح التي نشرها
    var comments: [CommentModel] // قائمة التعليقات التي نشرها الطبيب
    var likedArticles: [AdviceModel] // قائمة المقالات التي أعجب بها الطبيب

}




