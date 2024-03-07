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
    
    var body: some View {
        TabView {
            // MARK: Home Tab
            NavigationView {
                HomeView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }
            
            // MARK: Insights Tab
            NavigationView {
                InsightsView(healthKitViewModel: healthKitViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            // MARK: Dosing Tab
            NavigationView {
                DosingView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Dosing", systemImage: "pills.fill")
            }
            
            // MARK: Education Tab
            NavigationView {
                EducationView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
            }
            .tabItem {
                Label("Education", systemImage: "graduationcap.fill")
            }
        }
        .tint(Color.darkTeal)
        .onAppear(perform: {
            profileViewModel.loadProfileData()
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
