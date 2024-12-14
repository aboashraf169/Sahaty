//
//  AddAdviceSheetView.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import SwiftUI

struct AddAdviceSheetView: View {
    
     @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel = AdviceViewModel()

    var body: some View {
        VStack{
            Text("أضف النصيحة اليومية")
                .font(.title)
                .padding(.vertical)
            HStack{
                Spacer()
                Text("الموضوع")
                Image(systemName: "text.book.closed")
            }
            .padding(.horizontal,20)

            .foregroundStyle(.secondary)
            TextEditor(text: $viewModel.newAdvice)
                .frame(height: 150)
                .colorMultiply(Color(.secondarySystemBackground))
                .cornerRadius(25)
                .multilineTextAlignment(.trailing)
            
            
            Button {
                viewModel.addAdvice()
                presentationMode.wrappedValue.dismiss()

            } label: {
                    Text("نشر")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal,10)
                    .background(Color(.accent))
                    .cornerRadius(10)
                    .padding(.top)
                
                
            }

        }
        .padding()
    }
}

struct AdviceView: View {
    
    @StateObject private var adviceViewModel = AdviceViewModel()
    var advice : AdviceModel
    
    var body: some View {
        
            HStack{
//                Button(action: {
//                    if let index = adviceViewModel.Advicies.firstIndex(where: { $0.id == advice.id }) {
//                        adviceViewModel.deleteAdvice(at: IndexSet(integer: index))
//                    }
//                }) {
//                    Image(systemName: "trash")
//                        .foregroundStyle(.black)
//                }
//                    .padding(.trailing)
//                Button(action: {
//
//                }) {
//                    Image(systemName: "pencil")
//                        .foregroundStyle(.black)
//
//                }
                
                Spacer()

                Text(advice.title)
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(4)
                    .opacity(0.5)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 5,height: 20)
                    .foregroundStyle(.accent)
            }
            .padding(.top,10)
            .padding(.leading)
            .padding(.trailing,40)
        
    
        
    }
}


#Preview {
    AddAdviceSheetView()
}
