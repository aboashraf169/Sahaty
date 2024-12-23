//
//  Post.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.
//

import Foundation

struct ArticalModel: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var description: String
    var authorId: DoctorModel // ربط المقال بالطبيب
    var publishDate: Date
    var imagePost: String? // رابط صورة المقالة
    var comments: [UUID] = [] // التعليقات
    var likesCount: Int = 0
}




