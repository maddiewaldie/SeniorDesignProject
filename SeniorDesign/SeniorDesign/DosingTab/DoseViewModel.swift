//
//  DoseViewModel.swift
//  SeniorDesign
//
//  Created by Maddie on 1/1/24.
//

import Foundation

struct Dose: Identifiable, Codable {
    let id = UUID()
    let allergen: String
    let doseType: String
    var doseAmount: Double
    var halfDose: Double {
        return doseAmount / 2.0
    }
    var isCurrentDose: Bool // Add property to track current dose
}

class DoseViewModel: ObservableObject {
    @Published var doses: [Dose] = []
    
    // Function to add a dose with an option to mark it as current
    func addDose(allergen: String, doseType: String, doseAmount: Double, isCurrentDose: Bool) {
        var newDose = Dose(allergen: allergen, doseType: doseType, doseAmount: doseAmount, isCurrentDose: isCurrentDose)
        newDose.isCurrentDose = isCurrentDose // Mark the dose as current based on the flag
        doses.append(newDose)
        saveDoses()
    }
    
    func saveDoses() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(doses) {
            UserDefaults.standard.set(encoded, forKey: "Doses")
        }
    }
    
    func loadDoses() {
        if let savedDoses = UserDefaults.standard.data(forKey: "Doses") {
            let decoder = JSONDecoder()
            if let loadedDoses = try? decoder.decode([Dose].self, from: savedDoses) {
                doses = loadedDoses
            }
        }
    }
    
    // Function to set the current dose for a specific allergen
    func setCurrentDose(allergen: String, doseType: String) {
        for index in 0..<doses.count {
            if doses[index].allergen == allergen && doses[index].doseType == doseType {
                doses[index].isCurrentDose = true
            } else {
                doses[index].isCurrentDose = false
            }
        }
        saveDoses()
    }
}
