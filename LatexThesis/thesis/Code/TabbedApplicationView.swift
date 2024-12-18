//
//  TabbedApplicationView.swift
//  SeniorDesign
//
//  Created by Maddie on 8/20/23.
//

import SwiftUI

struct TabbedApplicationView: View {
    // MARK: View Models
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @EnvironmentObject var doseViewModel: DoseViewModel
    @EnvironmentObject var profileImageViewModel: ProfileModel

    var body: some View {
        TabView {
            // MARK: Home Tab
            NavigationStack {
                HomeView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
                    .environmentObject(profileImageViewModel)
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }
            
            // MARK: Insights Tab
            NavigationStack {
                InsightsView(healthKitViewModel: healthKitViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            // MARK: Dosing Tab
            NavigationStack {
                DosingView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Dosing", systemImage: "pills.fill")
            }
            
            // MARK: Education Tab
            NavigationStack {
                EducationView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Education", systemImage: "graduationcap.fill")
            }
        }
        .tint(.darkTeal)
        .onAppear(perform: {
            profileViewModel.loadProfileData()
            profileImageViewModel.loadProfileImage()
            doseViewModel.loadDoses()
        })
    }
}

// MARK: Preview
#Preview {
    TabbedApplicationView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HealthKitViewModel())
        .environmentObject(DoseViewModel())
}
