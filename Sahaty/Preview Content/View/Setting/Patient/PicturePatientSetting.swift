//
//  PicturePatientSetting.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct PicturePatientSetting: View {
//    var profilePicture: UIImage?
    var viewModel : PatientModel
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    
    var body: some View {
        VStack() {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
                else if let image = viewModel.profilePicture {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.accentColor)
                }
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "camera.fill")
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                .offset(x: -40, y: 40)
                
     
            }

        }
    }
}