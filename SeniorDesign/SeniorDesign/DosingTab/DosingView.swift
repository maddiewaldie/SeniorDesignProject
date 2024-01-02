//
//  DosingView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI

struct DosingView: View {
    // MARK: View Models
    @StateObject var doseViewModel = DoseViewModel()

    // MARK: Variables
    @State private var createNewDose = false
    @Environment(\.colorScheme) var colorScheme

    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: UI Elements
    var createNewDoseButton: some View {
        Button(action: {
            createNewDose = true
        }, label: {
            Image(systemName: "plus")
                .foregroundColor(Color.darkTeal)
        })
        .sheet(isPresented: $createNewDose, content: {
            AddDoseView()
                .environmentObject(doseViewModel)
        })
        .padding()
    }

    var header: some View {
        HStack {
            Text("Doses")
                .font(.largeTitle.bold())
                .padding()
            Spacer()
            createNewDoseButton
        }
    }

    var listOfDoses: some View {
        List {
            ForEach(doseViewModel.allergensWithDoses) { allergenWithDoses in
                Section(header: Text(allergenWithDoses.allergen).font(.title2).bold().foregroundColor(.black)) {
                    ForEach(allergenWithDoses.doses) { dose in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(dose.doseType)
                                    .font(.headline)
                                if dose.isCurrentDose {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(Color.darkTeal)
                                }
                            }
                            if let formattedDosage = numberFormatter.string(for: dose.doseAmount) {
                                Text("Dosage: \(formattedDosage) mg")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)

                        if let halfDosage = numberFormatter.string(for: dose.halfDose) {
                            VStack {
                                HStack {
                                    Text("Half Dose for \(dose.doseType)")
                                        .font(.headline)
                                    Spacer()
                                }
                                HStack {
                                    Text("Dosage: \(halfDosage) mg")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onAppear {
            doseViewModel.loadDoses()
        }
    }

    // MARK: Dosing View
    var body: some View {
        VStack(alignment: .leading) {
            header
            listOfDoses
        }
    }
}

// MARK: Dose View Model Extension
extension DoseViewModel {
    var allergensWithDoses: [AllergenWithDoses] {
        let groupedDoses = Dictionary(grouping: doses, by: { $0.allergen })
        let sortedAllergens = groupedDoses.keys.sorted()
        return sortedAllergens.map { allergen in
            AllergenWithDoses(allergen: allergen, doses: groupedDoses[allergen]!)
        }
    }
}


// MARK: Allergen with Doses
struct AllergenWithDoses: Identifiable {
    let id = UUID()
    let allergen: String
    let doses: [Dose]
}

// MARK: Preview
#Preview {
    DosingView()
}
