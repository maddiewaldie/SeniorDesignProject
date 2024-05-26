//
//  DosingViewTip.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import TipKit

struct DosingViewTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Add your OIT dosages here!")
    }

    var message: Text? {
        Text("Begin by tapping the + button to effortlessly add your doses. Once doses are added, simply swipe to access options for editing, deleting, or designating them as your current dose.")
    }

    var image: Image? {
        Image(systemName: "lightbulb.max.fill")
    }
}
