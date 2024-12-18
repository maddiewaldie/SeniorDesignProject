//
//  SeniorDesignApp.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import SwiftUI
import LocalAuthentication

let hasAppBeenOpenedBeforeKey = "HasAppBeenOpenedBefore"

class AppState: ObservableObject {
    @AppStorage(hasAppBeenOpenedBeforeKey) var hasAppBeenOpenedBefore: Bool = false
}

@main
struct OITApp: App {
    // MARK: View Models
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var healthKitViewModel = HealthKitViewModel()
    @StateObject var doseViewModel = DoseViewModel()
    @StateObject var profileImageViewModel = ProfileModel()
    @StateObject var appState = AppState()

    @State private var isUnlocked = false

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Allow OIT to use a passcode, TouchID, or FaceID to protect your data."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                    profileViewModel.loadProfileData()
                    profileImageViewModel.loadProfileImage()
                    doseViewModel.loadDoses()
                } else {
                    // Error
                }
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Allow OIT to use a passcode, TouchID, or FaceID to protect your data."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                    profileViewModel.loadProfileData()
                    profileImageViewModel.loadProfileImage()
                    doseViewModel.loadDoses()
                } else {
                    // Error
                }
            }
        }
    }

    // MARK: View of App
    var body: some Scene {
        WindowGroup {
            if appState.hasAppBeenOpenedBefore {
                TabbedApplicationView()
                    .environmentObject(profileViewModel)
                    .environmentObject(healthKitViewModel)
                    .environmentObject(doseViewModel)
                    .environmentObject(profileImageViewModel)
                    .onAppear(perform: {
                        profileViewModel.loadProfileData()
                        profileImageViewModel.loadProfileImage()
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
                    .environmentObject(appState)
                    .environmentObject(profileImageViewModel)
                    .onAppear {
                        profileViewModel.loadProfileData()
                        profileImageViewModel.loadProfileImage()
                        doseViewModel.loadDoses()
                    }
            }
        }
    }
}
