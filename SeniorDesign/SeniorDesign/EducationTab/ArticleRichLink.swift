//
//  ArticleRichLink.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct ArticleRichLink: View {
    // MARK: Variables
    @State private var isShowingArticle = false
    var articleTitle: String
    var articleDescription: String
    var articleContent: String
    var image: String

    @Environment(\.colorScheme) var colorScheme

    // MARK: Article Rich Link View
    var body: some View {
        NavigationLink(destination: ArticleView(articleTitle: articleTitle, articleDescription: articleContent, image: image))
        {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 30, height: 180)
                            .padding(.top, 0)
                            .padding(.bottom, 10)
                        HStack {
                            Text(articleTitle)
                                .font(.title2.bold())
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        Text(articleDescription)
                            .font(.body)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 30, height: 260)
                .background(colorScheme == .light ? Color.mediumGrey : Color.darkGrey)
                .cornerRadius(20)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
