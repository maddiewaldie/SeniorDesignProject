//
//  EducationView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import TipKit

struct ResourcesTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Stay Informed")
    }

    var message: Text? {
        Text("Explore our curated articles, hotlines, and useful links for valuable insights into food allergies and OIT. Empower yourself with knowledge to navigate your journey confidently!")
    }

    var image: Image? {
        Image(systemName: "books.vertical.circle")
    }
}

struct ESTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Emergency Assistance")
    }

    var message: Text? {
        Text("In case of an anaphylactic reaction, don't hesitate to call 911 immediately. Time is crucial. Stay calm, provide your location, and follow dispatcher instructions. Administer epinephrine if available, and if trained to do so.")
    }

    var image: Image? {
        Image(systemName: "phone.badge.checkmark")
    }
}

struct EducationView: View {
    // MARK: Variables
    let content = EducationViewContent()

    // MARK: UI Elements
    var articles: some View {
        VStack(alignment: .leading) {
            ArticleRichLink(articleTitle: "Anaphylaxis", articleDescription: "Learn the signs & symptoms of anaphylaxis.", articleContent: content.anaphylaxisTips, image: "anaphylaxis")
                .padding(7)
            ArticleRichLink(articleTitle: "OIT Best Practices", articleDescription: "Tips and tricks for Oral Immunotherapy.", articleContent: content.oitTips, image: "oit")
                .padding(7)
            ArticleRichLink(articleTitle: "Avoiding Cross Contamination", articleDescription: "Tips to help avoid cross contamination.", articleContent: content.crossContaminationTips, image: "crossContamination")
                .padding(7)
        }
    }

    var emergencyServicesInformation: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Emergency Services")
                    .font(.title3).bold()
                    .padding()
                Spacer()
            }
            if #available(iOS 17.0, *) {
                TipView(esTip, arrowEdge: .bottom)
                    .tipCornerRadius(15)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                    .padding(.trailing, 20)
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
            .background(Color.lightTeal)
            .cornerRadius(10)
        }
    }

    var fareInformation: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Food Allergy Research & Education")
                    .font(.title3).bold()
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
                .background(Color.lightTeal)
                .cornerRadius(10)

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
                .background(Color.lightTeal)
                .cornerRadius(10)
            }
        }
    }

    var resourcesTip = ResourcesTip()
    var esTip = ESTip()

    // MARK: Education Tab View
    var body: some View {
        VStack(alignment: .leading) {
            Text("Resources")
                .font(.largeTitle.bold())
                .padding()
            ScrollView {
                if #available(iOS 17.0, *) {
                    TipView(resourcesTip, arrowEdge: .none)
                        .tipCornerRadius(15)
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                }
                articles
                emergencyServicesInformation
                fareInformation
            }
        }
        .padding(.bottom, 20)
        .task {
            if #available(iOS 17.0, *) {
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
                Tips.showAllTipsForTesting()
            }
        }
    }
}

// MARK: Preview
#Preview {
    EducationView()
}
