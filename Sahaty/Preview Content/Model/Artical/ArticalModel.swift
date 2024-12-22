//
//  Post.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.
//

import Foundation

struct ArticalModel: Identifiable {
    var id = UUID() // معرف فريد للمقالة
    var description: String // محتوى المقالة
    var name: String // اسم الكاتب
    var userName: String // اسم المستخدم
    var addTime: String // وقت الإضافة
    var imagePost: String? // رابط صورة المقالة (اختياري)
    var personImage: String? // رابط صورة الكاتب (اختياري)

    var comments: [CommentModel] // قائمة التعليقات على المقالة
    var likedBy: [CommentAuthor]


    init(
        id: UUID = UUID(),
        description: String,
        name: String,
        userName: String,
        addTime: String,
        imagePost: String? = nil,
        personImage: String? = nil,
        comments: [CommentModel] = [], // قيمة افتراضية لقائمة التعليقات
        likedBy: [CommentAuthor] = [] // قيمة افتراضية لقائمة الإعجابات
    ) {
        self.id = id
        self.description = description
        self.name = name
        self.userName = userName
        self.addTime = addTime
        self.imagePost = imagePost
        self.personImage = personImage
        self.comments = comments
        self.likedBy = likedBy
    }
}



