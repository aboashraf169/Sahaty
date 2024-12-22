//
//  Specialization.swift
//  Sahaty
//
//  Created by mido mj on 12/21/24.
//

import Foundation


struct Specialization: Identifiable {
    let id = UUID()
    let name: String
    let doctors: [DoctorModel]
}
