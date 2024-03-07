//
//  DoseViewModel.swift
//  SeniorDesign
//
//  Created by Maddie on 1/1/24.
//

import Foundation

class DoseViewModel: ObservableObject {
    @Published var doses: [Dose] = []

    var allergensWithDoses: [AllergenWithDoses] {
        let groupedDoses = Dictionary(grouping: doses, by: { $0.allergen })
        let sortedAllergens = groupedDoses.keys.sorted()
        return sortedAllergens.map { allergen in
            AllergenWithDoses(allergen: allergen, doses: groupedDoses[allergen]!)
        }
    }

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

    func deleteDose(_ dose: Dose) {
        if let index = doses.firstIndex(where: { $0.id == dose.id }) {
            doses.remove(at: index)
            saveDoses()
        }
    }

    func setAsCurrentDose(_ dose: Dose) {
        for index in 0..<doses.count {
            if doses[index].allergen == dose.allergen {
                doses[index].isCurrentDose = doses[index].id == dose.id
            }
        }
        saveDoses()
    }

    func doseTypesForSelectedAllergens(selectedAllergens: [String]) -> [String] {
        var uniqueDoseTypes: [String] = []

        for allergen in selectedAllergens {
            let dosesForAllergen = doses.filter { $0.allergen == allergen }
            print(dosesForAllergen)
            let doseTypesForAllergen = Set(dosesForAllergen.map { "\($0.doseType) • \((String(format: "%.1f", $0.doseAmount))) mg" })
            print(doseTypesForAllergen)
            uniqueDoseTypes.append(contentsOf: doseTypesForAllergen)
        }

        return Array(Set(uniqueDoseTypes))
    }

    func updateDose(_ existingDose: Dose, allergen: String, doseType: String, doseAmount: Double, isCurrentDose: Bool) {
        if let index = doses.firstIndex(where: { $0.id == existingDose.id }) {
            doses[index].allergen = allergen
            doses[index].doseType = doseType
            doses[index].doseAmount = doseAmount
            doses[index].isCurrentDose = isCurrentDose
            saveDoses()
        }
    }
}
