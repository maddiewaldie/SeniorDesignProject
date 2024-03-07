//
//  Dose.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation

struct Dose: Identifiable, Codable {
    var id: UUID {
        return UUID()
    }
    var allergen: String
    var doseType: String
    var doseAmount: Double
    var halfDose: Double {
        return doseAmount / 2.0
    }
    var isCurrentDose: Bool // Add property to track current dose
}
