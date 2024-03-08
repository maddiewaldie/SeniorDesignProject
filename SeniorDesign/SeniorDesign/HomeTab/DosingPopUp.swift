//
//  DosingPopUp.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import CoreData

struct DosingPopUp: View {
    // MARK: View Models
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @EnvironmentObject var doseViewModel: DoseViewModel

    // MARK: Variables
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedDoses: [String: String] = [:]
    @State private var selectedAntihistamineDoses: [AntihistamineDose] = []
    @State private var doseTime = Date()
    @State private var notes = ""
    @State private var antihistamines: [String] = ["Benadryl", "Pepcid", "Zyrtec", "Other"]
    @State private var hidden: [Bool] = [true, true, true, true]
    @State private var dose: String = ""

    private var selectedAllergensArray: [String] {
        Array(profileViewModel.selectedAllergens)
    }

    let selectedDate: Date

    // MARK: Initializer
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
    }

    // MARK: UI Elements
    var allergensSectionHeader: some View {
        VStack {
            if (profileViewModel.profileData.allergens.count == 0) {
                HStack {
                    Text("Allergens")
                        .font(.headline)
                        .padding()
                        .padding(.bottom, 0)
                    Spacer()
                }
                HStack {
                    Text("⚠️ You haven't recorded any allergens in your profile. To add allergens, go to your profile settings in the Home tab and update the allergens section.")
                        .font(.body)
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width-20, height: 130)
                .background(Color.grey)
                .opacity(0.7)
                .padding(.top, 0)
                .cornerRadius(15)
            } else {
                HStack {
                    Text("Allergens")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
            }
        }
    }

    var allergensSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(profileViewModel.profileData.allergens, id: \.self) { allergen in
                Button(action: {
                    profileViewModel.toggleAllergenSelection(allergen)
                }) {
                    VStack {
                        Text(profileViewModel.profileData.allergenEmojiMap[allergen] ?? "")
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
    }

    var timeSectionHeader: some View {
        HStack {
            Text("Time of Dose")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    var timePicker: some View {
        DatePicker("Dose Time", selection: $doseTime, displayedComponents: .hourAndMinute)
            .datePickerStyle(CompactDatePickerStyle())
            .font(.body.bold())
            .labelsHidden()
            .padding(.leading, 20)
            .tint(.darkTeal)
    }

    var predoseHeader: some View {
        HStack {
            Text("Did you pre-dose any antihistamines before your oral immunotherapy dose?")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    var predoseSection: some View {
        VStack {
            ForEach(antihistamines.indices, id: \.self) { index in
                HStack {
                    Text(antihistamines[index])
                        .onTapGesture {
                            hidden[index].toggle()
                        }
                        .padding()
                    Spacer()
                    if !hidden[index] {
                        let selectedDose = Binding<String>(
                            get: {
                                selectedDoses[antihistamines[index]] ?? ""
                            },
                            set: { newValue in
                                selectedDoses[antihistamines[index]] = newValue
                            }
                        )
                        Picker("\(antihistamines[index])", selection: selectedDose) {
                            ForEach(1..<6, id: \.self) { dosage in
                                Text("\(dosage * 10) mg").tag("\(dosage * 10) mg")
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .tint(.darkTeal)
                    }
                }
                .padding(.horizontal, 20)
            }
            Divider()
                .padding(.horizontal, 20)
        }
    }



    var dosageSectionHeader: some View {
        HStack {
            if selectedAllergensArray.count > 0 {
                Text("Dosage for Allergens")
                    .font(.headline)
                    .padding()
                Spacer()
            }
        }
    }

    var dosageSection: some View {
        ForEach(selectedAllergensArray, id: \.self) { allergen in
            HStack {
                Text(allergen)
                    .padding(.leading, 20)
                Spacer()
                Picker("", selection: Binding(
                    get: {
                        selectedDoses[allergen] ?? ""
                    },
                    set: { newValue in
                        selectedDoses[allergen] = newValue
                    }
                )) {
                    let doseTypesForSelectedAllergens = doseViewModel.doseTypesForSelectedAllergens(selectedAllergens: [allergen])

                    ForEach(doseTypesForSelectedAllergens, id: \.self) { doseType in
                        let formattedDose = doseType.components(separatedBy: "•").last?
                            .replacingOccurrences(of: ".0", with: "") ?? ""
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        Text(formattedDose)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 10)
        }
    }



    var notesHeader: some View {
        HStack {
            Text("Notes")
                .font(.headline)
                .padding()
            Spacer()
        }
    }

    var notesSection: some View {
        TextField("Enter any notes about your dose here.", text: $notes)
            .textFieldStyle(DefaultTextFieldStyle())
            .padding(.leading, 20)
            .padding(.trailing, 20)
    }

    // MARK: Dosing Pop Up View
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    timeSectionHeader
                    timePicker

                    allergensSectionHeader
                    allergensSection

                    dosageSectionHeader
                    dosageSection

                    predoseHeader
                    predoseSection

                    notesHeader
                    notesSection
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

    // MARK: Functions
    func saveDoseInformation() {
        let context = healthKitViewModel.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "DoseRecord", in: context) else { return }
        let newDoseRecord = DoseRecord(entity: entity, insertInto: context)
        newDoseRecord.date = selectedDate
        newDoseRecord.time = doseTime
        newDoseRecord.notes = notes

        // Convert arrays to NSData or archive them before assigning to Core Data entity
        if let allergenData = try? NSKeyedArchiver.archivedData(withRootObject: selectedAllergensArray, requiringSecureCoding: false) as NSData? {
            newDoseRecord.selectedAllergens = allergenData
        }

        if let antihistamineData = try? NSKeyedArchiver.archivedData(withRootObject: selectedAntihistamineDoses, requiringSecureCoding: false) as NSData? {
            newDoseRecord.antihistamineDoses = antihistamineData
        }

        if let doseData = try? NSKeyedArchiver.archivedData(withRootObject: selectedDoses, requiringSecureCoding: false) as NSData? {
            newDoseRecord.doses = doseData
        }

        do {
            try context.save()
            _ = healthKitViewModel.fetchSymptomsFromCoreData(for: selectedDate)
            healthKitViewModel.fetchDoseRecords()
            doseViewModel.loadDoses()
            print("DoseRecord saved successfully.")
        } catch {
            print("Failed to save DoseRecord: \(error.localizedDescription)")
        }

        // Dismiss the pop-up
        presentationMode.wrappedValue.dismiss()
    }


}

// MARK: Preview
#Preview {
    DosingPopUp(selectedDate: Date())
        .environmentObject(ProfileViewModel())
        .environmentObject(HealthKitViewModel())
}
