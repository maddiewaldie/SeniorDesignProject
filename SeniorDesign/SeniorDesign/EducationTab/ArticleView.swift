//
//  ArticleView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct ArticleView: View {
    // MARK: Variables
    var articleTitle: String
    var articleDescription: String
    var image: String

    // MARK: Article View
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(articleTitle)
                        .font(.largeTitle.bold())
                        .padding()
                    Spacer()
                }
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 160)
                    .background(Color.lightTeal)
                    .cornerRadius(20)
                HStack {
                    Spacer()
                    Text(articleDescription)
                        .font(.body)
                        .padding(20)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
