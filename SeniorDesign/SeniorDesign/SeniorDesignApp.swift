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
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var healthKitViewModel = HealthKitViewModel()

    @AppStorage(hasAppBeenOpenedBeforeKey) var hasAppBeenOpenedBefore: Bool = false
        var body: some Scene {
            WindowGroup {
                if hasAppBeenOpenedBefore {
                    TabbedApplicationView()
                        .environmentObject(profileViewModel)
                        .environmentObject(healthKitViewModel)
                } else {
                    GetStartedView()
                        .environmentObject(profileViewModel)
                        .environmentObject(healthKitViewModel)
                }
            }
        }
}
