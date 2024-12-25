//
//  NotificationModel.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//


import SwiftUI

struct NotificationModel: Identifiable {
    let id = UUID()
    let senderName: String
    let senderEmail: String
    let message: String
}
