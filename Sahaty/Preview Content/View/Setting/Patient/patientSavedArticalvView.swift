//
//  patientSavedArticalvView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct patientSavedArticalvView: View {
    
    var articles: [ArticleModel]
    @State var DefultArticle : [ArticleModel] = []
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    
  

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(articles) { article in
                        ArticleView(
                            articlesModel: article,
                            articlesViewModel: ArticalsViewModel(),
                            usersType: .patient
                        )
                    }
                }
            }
            .navigationTitle("saved_articles".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة


    }
}

#Preview {
    patientSavedArticalvView(articles: [])
}

