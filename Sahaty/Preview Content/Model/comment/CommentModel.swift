//
//  Comment.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//


import Foundation

struct CommentModel: Identifiable, Codable {
    var id: Int // معرف التعليق
    var content: String // نص التعليق
    var authorName: String // اسم المعلق
    var authorImage: String? // صورة المعلق
    var createdAt: String // وقت النشر
}
