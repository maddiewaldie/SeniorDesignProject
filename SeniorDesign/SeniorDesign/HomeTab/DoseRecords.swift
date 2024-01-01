//
//  DoseRecords.swift
//  SeniorDesign
//
//  Created by Maddie on 12/28/23.
//

import Foundation

struct DoseRecord {
    let date: Date
    let time: Date
    let notes: String
    let selectedAllergens: Set<String>
    let doses: [String: String] // Dictionary to store allergens and their doses

    init(date: Date, time: Date, notes: String, selectedAllergens: Set<String>, doses: [String: String]) {
        self.date = date
        self.time = time
        self.notes = notes
        self.selectedAllergens = selectedAllergens
        self.doses = doses
    }
}

