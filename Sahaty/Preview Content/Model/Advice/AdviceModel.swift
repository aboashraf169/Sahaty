//
//  AdviceModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import Foundation


struct AdviceModel:  Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var content: String
    var authorId: UUID // ربط النصيحة بالطبيب
    var publishDate: Date

}

