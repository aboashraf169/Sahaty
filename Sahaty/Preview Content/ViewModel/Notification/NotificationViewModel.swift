//
//  NotificationViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []

    init() {
        // إضافة بيانات افتراضية
        loadDefaultNotifications()
    }

    private func loadDefaultNotifications() {
        notifications = [
            NotificationModel(senderName: "د. أحمد الخيري", senderEmail: "ahmedalkhairy@", message: "قام بنشر في نمط تلطف. قمت سابقًا بتفعيل إشعاراته."),
            NotificationModel(senderName: "د. أحمد الخيري", senderEmail: "ahmedalkhairy@", message: "قام بقبول طلب المراسلة الذي أرسلته." ),
            NotificationModel(senderName: "النظام", senderEmail: "system", message: "تم إضافة أقسام جديدة يمكنك التأكد منها الآن."),
            NotificationModel(senderName: "د. منى منصور", senderEmail: "mona_mansour@", message: "لسوء الحظ، رفضت د. منى منصور طلب التواصل."),
            NotificationModel(senderName: "د. منى منصور", senderEmail: "mona_mansour@", message: "قامت بإرسال رسالة خاصة لك."),
            NotificationModel(senderName: "د. أحمد الخيري", senderEmail: "ahmedalkhairy@", message: "قام بقبول طلب المراسلة الذي أرسلته." ),
            NotificationModel(senderName: "النظام", senderEmail: "system", message: "تم إضافة أقسام جديدة يمكنك التأكد منها الآن."),
            NotificationModel(senderName: "د. منى منصور", senderEmail: "mona_mansour@", message: "لسوء الحظ، رفضت د. منى منصور طلب التواصل."),
            NotificationModel(senderName: "د. منى منصور", senderEmail: "mona_mansour@", message: "قامت بإرسال رسالة خاصة لك."),
            NotificationModel(senderName: "د. أحمد الخيري", senderEmail: "ahmedalkhairy@", message: "قام بقبول طلب المراسلة الذي أرسلته." ),
            NotificationModel(senderName: "النظام", senderEmail: "system", message: "تم إضافة أقسام جديدة يمكنك التأكد منها الآن."),
            NotificationModel(senderName: "د. منى منصور", senderEmail: "mona_mansour@", message: "لسوء الحظ، رفضت د. منى منصور طلب التواصل."),
            NotificationModel(senderName: "د. منى منصور", senderEmail: "mona_mansour@", message: "قامت بإرسال رسالة خاصة لك.")
        ]
    }
}
