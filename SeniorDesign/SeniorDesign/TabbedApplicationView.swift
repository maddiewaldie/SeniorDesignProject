//
//  TabbedApplicationView.swift
//  SeniorDesign
//
//  Created by Maddie on 8/20/23.
//

import SwiftUI

struct TabbedApplicationView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }

            NavigationView {
                InsightsView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
            }
            .tabItem {
                Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationView {
               DosingView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
           }
           .tabItem {
               Label("Dosing", systemImage: "pills.fill")
           }

            NavigationView {
               EducationView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
           }
           .tabItem {
               Label("Education", systemImage: "graduationcap.fill")
           }
        }
        .tint(Color.darkTeal)
    }
}

#Preview {
    TabbedApplicationView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HealthKitViewModel())

}
