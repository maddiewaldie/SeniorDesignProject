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
        let newDose = Dose(allergen: allergen, doseType: doseType, doseAmount: doseAmount, isCurrentDose: isCurrentDose)
        doses.append(newDose)

        let halfDoseAmount = doseAmount / 2.0
        let newHalfDose = Dose(allergen: allergen, doseType: "Half Dose for \(doseType)", doseAmount: halfDoseAmount, isCurrentDose: false)
        doses.append(newHalfDose)

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

    func deleteDose(at index: Int) {
        doses.remove(at: index)
    }

    func setAsCurrentDose(_ dose: Dose) {
        for index in 0..<doses.count {
            if doses[index].id == dose.id {
                doses[index].isCurrentDose = true
            } else {
                doses[index].isCurrentDose = false
            }
        }
        saveDoses()
    }
}
