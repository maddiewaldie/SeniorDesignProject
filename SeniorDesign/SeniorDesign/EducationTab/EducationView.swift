//
//  EducationView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI

struct EducationView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Resources")
                .font(.largeTitle.bold())
                .padding()
            ScrollView {
                VStack(alignment: .leading) {
                    ArticleRichLink(articleTitle: "Anaphylaxis", articleDescription: "Learn the signs & symptoms of anaphylaxis.")
                        .padding()
                    ArticleRichLink(articleTitle: "OIT Best Practices", articleDescription: "Tips and tricks for Oral Immunotherapy.")
                        .padding()
                }
                VStack(alignment: .center) {
                    HStack {
                        Text("Emergency Services")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    Button(action: {
                        if let url = URL(string: "tel://911") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Text("911    ")
                            .font(.body)
                            .bold()
                            .foregroundColor(.black)
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .cornerRadius(20)
                    .background(Color.lightTeal)
                }
                VStack(alignment: .center) {
                    HStack {
                        Text("Food Allergy Research and Education")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    HStack{
                        Button(action: {
                            if let url = URL(string: "https://www.foodallergy.org") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "safari.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Text("Website    ")
                                .font(.body)
                                .bold()
                                .foregroundColor(.black)
                        }
                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 50)
                        .cornerRadius(20)
                        .background(Color.lightTeal)
                        
                        Button(action: {
                            if let url = URL(string: "tel://18009294040") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            Image(systemName: "phone.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Text("Phone       ")
                                .font(.body)
                                .bold()
                                .foregroundColor(.black)
                        }
                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 50)
                        .cornerRadius(20)
                        .background(Color.lightTeal)
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    EducationView()
}
