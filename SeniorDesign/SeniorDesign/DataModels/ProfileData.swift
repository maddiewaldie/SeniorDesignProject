//
//  ProfileData.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

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
