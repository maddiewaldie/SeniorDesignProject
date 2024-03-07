//
//  ResourcesTip.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import TipKit

struct ResourcesTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Stay Informed")
    }

    var message: Text? {
        Text("Explore our curated articles, hotlines, and useful links for valuable insights into food allergies and OIT. Empower yourself with knowledge to navigate your journey confidently!")
    }

    var image: Image? {
        Image(systemName: "books.vertical.circle")
    }
}
