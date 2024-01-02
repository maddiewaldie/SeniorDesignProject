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

    // MARK: Add Dose View
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Allergen")) {
                    Picker("Select Allergen", selection: $selectedAllergen) {
                        ForEach(profileViewModel.profileData.allergens, id: \.self) { allergen in
                            Text(allergen)
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
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("mg")
                    }
                }

                Section(header: Text("Mark as Current Dose")) {
                    Toggle("Current Dose", isOn: $isCurrentDose)
                }
            }
            .navigationTitle("Add Dose")
            .navigationBarItems(trailing:
                Button("Save") {
                    if let dosage = Double(doseAmount), !doseAmount.isEmpty {
                        doseViewModel.addDose(allergen: selectedAllergen, doseType: doseName, doseAmount: dosage, isCurrentDose: isCurrentDose)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}
