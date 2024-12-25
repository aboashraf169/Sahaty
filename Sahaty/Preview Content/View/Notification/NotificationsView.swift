//
//  NotificationsView.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.notifications) { notification in
                    HStack(alignment: .top, spacing: 10) {
                        // أيقونة الإشعار
                        Image(systemName: "bell.badge.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.accent)
                            .frame(width: 30, height: 30)

                        // تفاصيل الإشعار
                        VStack(alignment: .leading, spacing: 5) {
                            Text(notification.senderName)
                                    .font(.subheadline)
                            Text(notification.senderEmail)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            
                            Text(notification.message)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(nil)
                                .padding(.top,10)
                        }
                    }
                    .padding(8)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("الإشعارات")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
