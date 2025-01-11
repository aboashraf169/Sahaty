//
//  patientSavedArticalvView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct patientSavedArticalvView: View {
    
    var articles: [ArticalModel]
    @State var DefultArticle : [ArticalModel] = []
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    
    init() {
        let defaultArticles = [
            ArticalModel(description: "التغذية السليمة تعزز من صحة الجسم وتقي من الأمراض المزمنة.", name: "د.احمد عيسى", userName: "ahmad@", addTime: "ساعة", imagePost: "post"),
            ArticalModel(description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "د.محمد اشرف", userName: "@midoMj", addTime: "ساعتين"),
            ArticalModel(description: "التغذية السليمة تعزز من صحة الجسم وتقي من الأمراض المزمنة.", name: "د.احمد عيسى", userName: "ahmad@", addTime: "ساعة", imagePost: "post"),
            ArticalModel(description: "التغذية السليمة تعزز من صحة الجسم وتقي من الأمراض المزمنة.", name: "د.احمد عيسى", userName: "ahmad@", addTime: "ساعة", imagePost: "post"),
            ArticalModel(description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "د.محمد اشرف", userName: "@midoMj", addTime: "ساعتين"),
            ArticalModel(description: "التغذية السليمة تعزز من صحة الجسم وتقي من الأمراض المزمنة.", name: "د.احمد عيسى", userName: "ahmad@", addTime: "ساعة", imagePost: "post")
        ]
        self.articles = defaultArticles
        self._DefultArticle = State(initialValue: defaultArticles)


    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(articles) { article in
                        ArticleView(
                            articlesModel: article,
                            articlesViewModel: ArticalsViewModel(),
                            userType: .patient
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
    patientSavedArticalvView()
}

