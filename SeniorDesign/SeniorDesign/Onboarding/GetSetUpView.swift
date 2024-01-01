//
//  GetSetUpView.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import SwiftUI

struct GetSetUpView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Set Up")
                    .font(.largeTitle.bold())

                Text("Fill out the following information to get started.")
                    .font(.subheadline)
                    .padding(.top, 1)

                SettingsView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)

                Spacer()

                HStack(alignment: .center) {
                    NavigationLink(destination: TabbedApplicationView().navigationBarBackButtonHidden(true)) {
                        Spacer()
                        Text("Get Started                    ")
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color.darkTeal)
                            .cornerRadius(30)
                        Spacer()
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

struct GetSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        GetSetUpView()
            .environmentObject(ProfileViewModel())
            .environmentObject(HealthKitViewModel())
    }
}
