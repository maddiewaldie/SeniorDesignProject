//
//  ArticleView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct ArticleView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Article Title")
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
            }
            VStack {
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: 160)
            .background(Color.lightTeal)
            .cornerRadius(20)
            HStack {
                Text("Article information goes here!")
                    .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    ArticleView()
}
