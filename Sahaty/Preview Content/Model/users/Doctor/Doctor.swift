//
//  Doctor.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation


struct DoctorModel: Identifiable, Codable, Equatable {
    var user: UserModel 
    var specialization: String
    var licenseNumber: String
    var biography: String?
    var articleIds: [UUID] = []
    var adviceIds: [UUID] = []
    var isFavorite: Bool = false
    
    var id: UUID { user.id }
}
