//
//  Post.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.
//

import Foundation



struct ArticleModel: Identifiable, Codable {
    var id: Int
    var title: String
    var subject: String
    var img: String?
    var userID: Int
    var createdAt: String
    var updatedAt: String
}
