//
//  GetSetUpView.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import SwiftUI

struct GetSetUpView: View {
    // MARK: View Models
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel

    // MARK: UI Elements
    var setUpTitle: some View {
        Text("Set Up")
            .font(.largeTitle.bold())
    }

    var setUpInstructions: some View {
        Text("Fill out the following information to get started.")
            .font(.subheadline)
            .padding(.top, 1)
    }

    var getStartedButton: some View {
        Text("Get Started                    ")
            .font(.caption)
            .foregroundColor(Color.white)
            .padding()
            .background(Color.darkTeal)
            .cornerRadius(30)
    }

    // MARK: Get Set Up View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                setUpTitle
                setUpInstructions
                SettingsView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                Spacer()
                HStack(alignment: .center) {
                    NavigationLink(destination: TabbedApplicationView().navigationBarBackButtonHidden(true)) {
                        Spacer()
                        getStartedButton
                        Spacer()
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

// MARK: Preview
#Preview {
    GetSetUpView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HealthKitViewModel())
}
