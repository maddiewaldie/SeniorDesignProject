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
    @AppStorage(hasAppBeenOpenedBeforeKey) var hasAppBeenOpenedBefore: Bool = false
        var body: some Scene {
            WindowGroup {
                if hasAppBeenOpenedBefore {
                    TabbedApplicationView()
                } else {
                    GetStartedView()
                }
            }
        }
}
