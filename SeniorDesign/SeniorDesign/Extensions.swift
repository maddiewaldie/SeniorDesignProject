//
//  Extensions.swift
//  SeniorDesign
//
//  Created by Maddie on 9/25/23.
//

import Foundation
import SwiftUI

// Extension for custom application colors
extension Color {
    static var grey: Color { Color(hex: "D5D5D5") }
    static var darkTeal: Color { Color(hex: "5A8F8F") }
    static var lightTeal: Color { Color(hex: "C3E2E7") }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }

    static var mutedRandom: Color {
        let red = CGFloat.random(in: 0.2...0.8)
        let green = CGFloat.random(in: 0.2...0.8)
        let blue = CGFloat.random(in: 0.2...0.8)

        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

extension String {
    func splitCamelCase() -> String {
        var formattedString = self.replacingOccurrences(of: "HKCategoryTypeIdentifier", with: "")

        let pattern = "(\\w)([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: formattedString.utf16.count)

        let matches = regex.matches(in: formattedString, options: [], range: range)
        for match in matches.reversed() {
            let index = formattedString.index(formattedString.startIndex, offsetBy: match.range(at: 2).location)
            if index < formattedString.endIndex {
                formattedString.insert(" ", at: index)
            }
        }

        return formattedString
    }
}
