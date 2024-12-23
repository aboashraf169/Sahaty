//
//  Patient.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//

import Foundation


struct PatientModel: Identifiable, Codable, Equatable {
    
    var user: UserModel
    var followedDoctorIds: [UUID] = [] // قائمة الأطباء المتابعين
    var favoriteArticleIds: [UUID] = [] // قائمة المقالات المفضلة
    var favoriteAdviceIds: [UUID] = []
    
    var id: UUID { user.id }
}
