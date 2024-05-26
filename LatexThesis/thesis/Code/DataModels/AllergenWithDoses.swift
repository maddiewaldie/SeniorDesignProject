//
//  AllergenWithDoses.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation

struct AllergenWithDoses: Identifiable, Hashable {
    static func == (lhs: AllergenWithDoses, rhs: AllergenWithDoses) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    let id = UUID()
    let allergen: String
    let doses: [Dose]
}
