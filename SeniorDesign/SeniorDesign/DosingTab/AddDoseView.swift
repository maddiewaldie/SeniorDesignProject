//
//  AddDoseView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct AddDoseView: View {
    // MARK: View Models
    @EnvironmentObject var doseViewModel: DoseViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel

    // MARK: Variables
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedAllergen = ""
    @State private var doseName = ""
    @State private var doseAmount = ""
    @State private var isCurrentDose = false
    @State var editingDose: Dose?

    // MARK: Add Dose View
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Allergen")) {
                    Picker("Select Allergen", selection: $selectedAllergen) {
                        ForEach(profileViewModel.profileData.allergens, id: \.self) { allergen in
                            Text(allergen)
                        }
                    }
                    .onAppear {
                        if selectedAllergen.isEmpty, let firstAllergen = profileViewModel.profileData.allergens.first {
                            selectedAllergen = firstAllergen
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }

                Section(header: Text("Dose Information")) {
                    TextField("Dose Name", text: $doseName)
                    HStack {
                        Text("Dose")
                        Spacer()
                        TextField("", text: $doseAmount)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("mg")
                    }
                }

                Section(header: Text("Mark as Current Dose")) {
                    Toggle("Current Dose", isOn: $isCurrentDose)
                }
            }
            .onAppear {
                if let editingDose = editingDose {
                    selectedAllergen = editingDose.allergen
                    doseName = editingDose.doseType
                    doseAmount = "\(editingDose.doseAmount)"
                    isCurrentDose = editingDose.isCurrentDose
                }
            }
            .navigationTitle(editingDose != nil ? "Edit Dose" : "Add Dose")
                .navigationBarItems(trailing:
                    Button("Save") {
                        if let dosage = Double(doseAmount), !doseAmount.isEmpty {
                            if let editingDose = editingDose {
                                // Update existing dose
                                doseViewModel.updateDose(editingDose, allergen: selectedAllergen, doseType: doseName, doseAmount: dosage, isCurrentDose: isCurrentDose)
                            } else {
                                // Add new dose
                                doseViewModel.addDose(allergen: selectedAllergen, doseType: doseName, doseAmount: dosage, isCurrentDose: isCurrentDose)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                )
        }
    }
}
