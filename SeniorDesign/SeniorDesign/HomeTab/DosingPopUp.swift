//
//  DosingPopUp.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI

struct DosingPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @State private var selectedDoses: [String: String] = [:]
    @State private var doseTime = Date()
    let selectedDate: Date

    private var selectedAllergensArray: [String] {
        Array(profileViewModel.selectedAllergens)
    }

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
    }

    @State private var notes = ""
    @State private var antihistamines: [String] = ["Benadryl", "Pepcid", "Zyrtec", "Other"]
    @State private var hidden: [Bool] = [true, true, true, true]
    @State private var dose: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Allergens")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(profileViewModel.allergens, id: \.self) { allergen in
                                Button(action: {
                                    profileViewModel.toggleAllergenSelection(allergen)
                                }) {
                                    VStack {
                                        Text(profileViewModel.allergenEmojiMap[allergen] ?? "")
                                            .padding(.bottom, 10)
                                            .font(.title)
                                        Text(allergen)
                                            .bold()
                                            .foregroundColor(profileViewModel.isSelected(allergen) ? Color.white : Color.black)
                                    }
                                    .frame(width: 80, height: 100)
                                    .padding()
                                    .background(profileViewModel.isSelected(allergen) ? Color.darkTeal : Color.lightTeal)
                                    .cornerRadius(20)
                                }
                            }
                        }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                    HStack {
                        Text("Time")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    DatePicker("Dose Time", selection: $doseTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .font(.body.bold())
                        .labelsHidden()
                        .padding(.leading, 20)
                        .tint(Color.darkTeal)

                    HStack {
                        Text("Did you pre-dose any antihistamines before your oral immunotherapy dose?")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    VStack {
                        ForEach(0..<antihistamines.count) { med in
                            Divider()
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            HStack {
                                Text(antihistamines[med])
                                    .onTapGesture(perform: {
                                        hidden[med].toggle()
                                    })
                                Spacer()
                                Picker("\(antihistamines[med])", selection: $dose) {
                                    ForEach(1..<6) { dosage in
                                        Text("\(dosage * 10) mg")
                                    }
                                }
                                .pickerStyle(DefaultPickerStyle())
                                .tint(Color.darkTeal)
                                .opacity(hidden[med] ? 0 : 1)
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        }
                        Divider()
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }

                    HStack {
                        Text("Dosage for Allergens")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }

                    ForEach(selectedAllergensArray, id: \.self) { allergen in
                        HStack {
                            Text(allergen)
                                .padding(.leading, 20)
                            Spacer()
                            Picker("", selection: Binding(
                                get: {
                                    Int(selectedDoses[allergen] ?? "0") ?? 0
                                },
                                set: { newValue in
                                    selectedDoses[allergen] = "\(newValue)"
                                }
                            )) {
                                ForEach(0..<6) { dosage in
                                    Text("\(dosage * 10) mg").tag(dosage)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 120)

                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 10)
                    }

                    HStack {
                        Text("Notes")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    TextField("Enter any notes here.", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .navigationBarTitle("Dose Information")
                .navigationBarItems(trailing: Button("Done") {
                    saveDoseInformation()
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }

    func saveDoseInformation() {
            // Here you can create and save a DoseRecord using the doseTime, notes, and other selected data
        let newDoseRecord = DoseRecord(date: selectedDate, time: doseTime, notes: notes, selectedAllergens: profileViewModel.selectedAllergens, doses: selectedDoses)

            // Example: Assuming you have a function to save DoseRecords in your HealthKitViewModel
            healthKitViewModel.saveDoseRecord(newDoseRecord)

            // Perform any other actions needed after saving the dose record
        }
}

#Preview {
    DosingPopUp(selectedDate: Date())
        .environmentObject(ProfileViewModel())
        .environmentObject(HealthKitViewModel())
}
