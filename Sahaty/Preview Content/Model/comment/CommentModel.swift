//
//  Comment.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//


import Foundation

struct  CommentModel: Identifiable ,Codable{
    var id = UUID() // معرف فريد للتعليق
    var text: String // نص التعليق
    var author: CommentAuthor
    var publishDate: Date // تاريخ نشر التعليق
    var likeCount: Int = 0
    var CommentCount: Int = 0
}

