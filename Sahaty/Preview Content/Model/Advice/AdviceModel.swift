//
//  AdviceModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import Foundation

struct AdviceModel: Identifiable ,Equatable{
    let id = UUID()
    var content: String
    var authorName: String
    var publishDate: Date
}
