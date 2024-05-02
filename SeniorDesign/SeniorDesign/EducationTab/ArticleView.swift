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
    var articleDescription: AttributedString
    var articleDisclaimer: AttributedString
    var image: String

    @Environment(\.colorScheme) var colorScheme

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
                    VStack {
                        Text(articleDisclaimer)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .background(Color.lightYellow)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .padding(.top, 20)
                        Text(articleDescription)
                            .padding(20)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
