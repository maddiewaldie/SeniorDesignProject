//
//  ArticleRichLink.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct ArticleRichLink: View {
    var articleTitle: String
    var articleDescription: String
    @State private var isShowingArticle = false

    var body: some View {
        Button(action: {
            isShowingArticle.toggle()
        }) {
            ZStack(alignment: .bottom) {
                VStack {
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                .background(Color.lightTeal)
                .cornerRadius(20)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(articleTitle)
                                .font(.title2.bold())
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        Text(articleDescription)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: 100)
                .background(Color.grey)
                .cornerRadius(20)
            }
        }
        .sheet(isPresented: $isShowingArticle) {
            ArticleView()
        }
    }
}
