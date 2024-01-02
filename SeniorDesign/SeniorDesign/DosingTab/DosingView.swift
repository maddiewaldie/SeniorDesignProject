//
//  DosingView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI

struct DosingView: View {
    @State private var createNewDose = false
    @StateObject var doseViewModel = DoseViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Doses")
                        .font(.largeTitle.bold())
                        .padding()
                    Spacer()
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
                Spacer()
            }
            Spacer()
        }
    }
}



extension DoseViewModel {
    var allergensWithDoses: [AllergenWithDoses] {
        // Group doses by allergen
        let groupedDoses = Dictionary(grouping: doses, by: { $0.allergen })
        // Convert to array of AllergenWithDoses
        return groupedDoses.map { AllergenWithDoses(allergen: $0.key, doses: $0.value) }
    }
}

struct AllergenWithDoses: Identifiable {
    let id = UUID()
    let allergen: String
    let doses: [Dose]
}

#Preview {
    DosingView()
}
