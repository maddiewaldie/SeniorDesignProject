//
//  SeniorDesignApp.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import SwiftUI

let hasAppBeenOpenedBeforeKey = "HasAppBeenOpenedBefore"

@main
struct OITApp: App {
    // MARK: View Models
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var healthKitViewModel = HealthKitViewModel()
    @StateObject var doseViewModel = DoseViewModel()
    
    @AppStorage(hasAppBeenOpenedBeforeKey) var hasAppBeenOpenedBefore: Bool = false
    
    // MARK: View of App
    var body: some Scene {
        WindowGroup {
            if hasAppBeenOpenedBefore {
                TabbedApplicationView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
                    .onAppear {
                        profileViewModel.loadProfileData()
                    }
            } else {
                GetStartedView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
                    .onAppear {
                        hasAppBeenOpenedBefore = true
                        profileViewModel.loadProfileData()
                    }
            }
        }
    }
}
