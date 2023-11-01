//
//  AboutYourDoseView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct AboutYourDoseView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("About Your Dose")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 5)
                    Spacer()
                }
                HStack {
                    Text("Peanut")
                        .padding(.leading, 20)
                    Text("•")
                    Text("1500 mg")
                    Spacer()
                }
                .foregroundColor(.black)
                HStack {
                    Text("Milk")
                        .padding(.leading, 20)
                    Text("•")
                    Text("100 mg")
                    Spacer()
                }
                .foregroundColor(.black)
                .padding(.bottom, 10)
                HStack {
                    Text("7:30pm")
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                    Spacer()
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 150)
            .background(Color.lightTeal)
            .cornerRadius(20)
            HStack {
                Spacer()
                Image(systemName: "pills.fill")
                    .font(.system(size: 90))
                    .foregroundColor(Color.darkTeal)
                    .padding(.trailing, 35)
            }

        }
    }
}

#Preview {
    AboutYourDoseView()
}
