//
//  PersonalInformation.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import Foundation
import Combine

import Foundation

class ProfileData: ObservableObject, Codable {
    @Published var name: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var allergens: [String] = []
    @Published var shareDataWithAppleHealth: Bool = false
    @Published var useFaceID: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
        case dateOfBirth
        case allergens
        case shareDataWithAppleHealth
        case useFaceID
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        dateOfBirth = try container.decode(Date.self, forKey: .dateOfBirth)
        allergens = try container.decode([String].self, forKey: .allergens)
        shareDataWithAppleHealth = try container.decode(Bool.self, forKey: .shareDataWithAppleHealth)
        useFaceID = try container.decode(Bool.self, forKey: .useFaceID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(allergens, forKey: .allergens)
        try container.encode(shareDataWithAppleHealth, forKey: .shareDataWithAppleHealth)
        try container.encode(useFaceID, forKey: .useFaceID)
    }

    init() { } 
}


class ProfileViewModel: ObservableObject {
    @Published var profileData = ProfileData()
    @Published var selectedAllergens: Set<String> = []
    @Published var allergens: [String] = []

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

    // Function to remove an allergen
    func removeSelectedAllergen(at index: Int) {
        if profileData.allergens.indices.contains(index) {
            profileData.allergens.remove(at: index)
        }
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
