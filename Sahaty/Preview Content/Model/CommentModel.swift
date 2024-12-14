//
//  Comment.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//


import Foundation

struct CommentModel: Identifiable {
    let id = UUID()
    let username: String
    let image: String? 
    var text: String
}
