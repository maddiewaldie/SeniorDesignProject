//
//  TabbedApplicationView.swift
//  SeniorDesign
//
//  Created by Maddie on 8/20/23.
//

import SwiftUI

struct TabbedApplicationView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }

            NavigationView {
                InsightsView()
            }
            .tabItem {
                Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
            }

            NavigationView {
               DosingView()
           }
           .tabItem {
               Label("Dosing", systemImage: "pills.fill")
           }

            NavigationView {
               EducationView()
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
}
