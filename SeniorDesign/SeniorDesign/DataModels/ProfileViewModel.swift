//
//  PersonalInformation.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import Combine
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profileData = ProfileData()
    @Published var selectedAllergens: Set<String> = []
    @Published var numAllergens = 0 // Variable to track the number of allergens

    func saveProfileData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profileData) {
            UserDefaults.standard.set(encoded, forKey: "ProfileData")
        }
    }

    func loadProfileData() {
        if let savedProfileData = UserDefaults.standard.data(forKey: "ProfileData") {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(ProfileData.self, from: savedProfileData) {
                profileData = loadedProfile
                numAllergens = loadedProfile.allergens.count
            }
        }
    }

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

    func addNewAllergen() {
        profileData.allergens.append("Select an Allergen")
        numAllergens += 1 // Increment the allergen count
        saveProfileData()
    }

    func removeSelectedAllergen(at index: Int) {
        if profileData.allergens.indices.contains(index) {
            profileData.allergens.remove(at: index)
            numAllergens -= 1 // Decrement the allergen count
            saveProfileData()
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
