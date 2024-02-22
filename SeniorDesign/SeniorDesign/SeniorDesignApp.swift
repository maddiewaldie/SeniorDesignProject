//
//  SeniorDesignApp.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import SwiftUI
import LocalAuthentication

let hasAppBeenOpenedBeforeKey = "HasAppBeenOpenedBefore"

@main
struct OITApp: App {
    // MARK: View Models
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var healthKitViewModel = HealthKitViewModel()
    @StateObject var doseViewModel = DoseViewModel()
    
    @AppStorage(hasAppBeenOpenedBeforeKey) var hasAppBeenOpenedBefore: Bool = false

    @State private var isUnlocked = false

    func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Allow OIT to use a passcode, TouchID, or FaceID to protect your data."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    // Error
                }
            }
        }
    }

    // MARK: View of App
    var body: some Scene {
        WindowGroup {
            if hasAppBeenOpenedBefore {
                TabbedApplicationView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
                    .onAppear(perform: {
                        profileViewModel.loadProfileData()
                        doseViewModel.loadDoses()
                        if !isUnlocked && profileViewModel.profileData.useFaceID {
                            authenticate()
                        }
                    })
                    .onDisappear(perform: {
                        isUnlocked = false
                    })
            } else {
                GetStartedView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
                    .onAppear {
                        hasAppBeenOpenedBefore = true
                        profileViewModel.loadProfileData()
                        doseViewModel.loadDoses()
                    }
            }
        }
    }
}
