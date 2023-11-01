//
//  SettingsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import HealthKit

let healthStore = HKHealthStore()

struct SettingsView: View {
    @State private var name = ""
    @State private var selectedAllergen = ""
    @State private var dateOfBirth = Date()
    @State private var allergens: [String] = []
    @State private var shareDataWithAppleHealth = false
    @State private var useFaceID = false
    @EnvironmentObject var vm: HealthKitViewModel

    let commonAllergens = ["Peanuts", "Milk", "Eggs", "Fish", "Shellfish", "Soy", "Tree Nuts", "Wheat"]

    var body: some View {
            VStack(alignment: .leading) {
            Section(header: Text("Personal Information").font(.title3).bold()) {
                HStack {
                    Text("Name")
                        .font(.body.bold())
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing, 5)
                }

                DatePicker("Birthdate", selection: $dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                    .font(.body.bold())
            }
            .padding(.top, 10)

            Divider()
                .padding()

            Section(header: SectionHeaderView(title: "Allergens", action: {
                allergens.append("") // Add an empty allergen
            })) {
                ForEach(0..<allergens.count, id: \.self) { index in
                    HStack {
                        Picker("Select an Allergen", selection: $allergens[index]) {
                            ForEach(commonAllergens, id: \.self) { allergen in
                                Text(allergen).tag(allergen)
                            }
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .padding(.bottom, 10)
                    }
                }
            }

            Divider()
                .padding()

            Section(header: Text("Preferences").font(.title3).bold()) {
                Toggle("Share Data with Apple Health", isOn: $shareDataWithAppleHealth)
                    .toggleStyle(SwitchToggleStyle(tint: Color.darkTeal))
                    .onChange(of: shareDataWithAppleHealth) { newValue in
                        vm.healthRequest()
                    }

                Toggle("Protect data with FaceID", isOn: $useFaceID)
                    .toggleStyle(SwitchToggleStyle(tint: Color.darkTeal))
            }
            .padding(.top, 10)
            Spacer()
        }
            .padding()
    }
}

struct SectionHeaderView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
            Spacer()
            Button(action: action) {
                Image(systemName: "plus")
                    .foregroundColor(Color.darkTeal)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsView()
        .environmentObject(HealthKitViewModel())
}
