//
//  GetStartedView.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import SwiftUI

struct GetStartedView: View {
    var getStartedButton: some View {
        NavigationLink(destination: GetSetUpView().navigationBarBackButtonHidden(true)) {
            Text("Get Started         ")
                .font(.caption)
                .foregroundColor(Color.white)
                .padding()
                .background(Color.darkTeal)
                .cornerRadius(30)
        }
        .padding()
    }

    var appTitle: some View {
        VStack {
            Spacer()
            Text("OIT")
                .font(.largeTitle.bold().monospaced())
                .foregroundColor(.white)
                .padding(.bottom, 1)
            Text("oral immunotherapy tracker")
                .font(.callout.lowercaseSmallCaps())
                .fontDesign(.rounded)
                .foregroundColor(.white)
                .padding(.bottom, 20)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color.darkTeal
                        .frame(maxHeight: .infinity)
                    appTitle
                    VStack {
                        Spacer()
                        Text("OIT")
                            .font(.largeTitle.bold().monospaced())
                            .foregroundColor(.white)
                            .padding(.bottom, 1)
                        Text("oral immunotherapy tracker")
                            .font(.callout.lowercaseSmallCaps())
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                    }
                }
                VStack {}
                ZStack {
                    Color.lightTeal
                        .frame(maxHeight: .infinity)

                    VStack {
                        getStartedButton
                        Spacer()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}
