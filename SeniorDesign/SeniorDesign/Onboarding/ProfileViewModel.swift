//
//  PersonalInformation.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var allergens: [String] = []
    @Published var selectedAllergens: Set<String> = []
    @Published var shareDataWithAppleHealth: Bool = false
    @Published var useFaceID: Bool = false

//    var availableAllergens = ["Peanuts", "Milk", "Eggs", "Fish", "Shellfish", "Soy", "Tree Nuts", "Almonds", "Brazil Nuts", "Cashews", "Hazelnuts", "Macadamia Nuts", "Pecans", "Pine Nuts", "Pistachios", "Walnuts", "Wheat", "Sesame"]

    let allergenEmojiMap: [String: String] = [
        "Peanuts": "🥜",
        "Almonds": "🌰",
        "Brazil Nuts": "🌰",
        "Cashews": "🌰",
        "Hazelnuts": "🌰",
        "Macadamia Nuts": "🌰",
        "Pecans": "🌰",
        "Pine Nuts": "🌰",
        "Pistachios": "🌰",
        "Walnuts": "🌰",
        "Milk": "🥛",
        "Eggs": "🍳",
        "Wheat": "🌾",
        "Soy": "🌱",
        "Fish": "🐟",
        "Shellfish": "🦞",
        "Sesame": "🌿",
    ]

    // Function to remove an allergen
    func removeSelectedAllergen(at index: Int) {
        if allergens.indices.contains(index) {
            allergens.remove(at: index)
        }
    }

    func toggleAllergenSelection(_ allergen: String) {
        if selectedAllergens.contains(allergen) {
            selectedAllergens.remove(allergen)
        } else {
            selectedAllergens.insert(allergen)
        }
    }

    func isSelected(_ allergen: String) -> Bool {
        return selectedAllergens.contains(allergen)
    }
}
