//
//  AdviceModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import Foundation

struct AdviceModel: Identifiable, Codable {
    var id: Int
    var advice: String
    var doctorID: Int
    var createdAt: String
    var updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case advice
        case doctorID = "doctor_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


