//
//  InsightsTip.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import TipKit

struct InsightsTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Unlock Your Health Insights")
    }

    var message: Text? {
        Text("Discover personalized stats and insightful graphs based on your symptoms and doses. Track your progress, gain valuable health insights, and make informed decisions on your journey to wellness.")
    }

    var image: Image? {
        Image(systemName: "waveform.badge.magnifyingglass")
    }
}
