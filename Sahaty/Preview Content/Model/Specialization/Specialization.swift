//
//  Specialization.swift
//  Sahaty
//
//  Created by mido mj on 12/21/24.
//

import Foundation


struct Specialization: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let doctorIds: [UUID] // قائمة IDs للأطباء المرتبطين
}

