//
//  SettingsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import HealthKit
import SwiftUI

struct SettingsView: View {
    // MARK: View Models
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @EnvironmentObject var doseViewModel: DoseViewModel


    // MARK: Variables
    let commonAllergens = ["Peanuts", "Milk", "Eggs", "Fish", "Shellfish", "Soy", "Tree Nuts", "Almonds", "Brazil Nuts", "Cashews", "Hazelnuts", "Macadamia Nuts", "Pecans", "Pine Nuts", "Pistachios", "Walnuts", "Wheat", "Sesame"]

    // MARK: UI Elements
    var personalInformationSection: some View {
        Section(header: Text("Personal Information").font(.title3).bold()) {
            HStack {
                Text("Name")
                    .font(.body.bold())
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                TextField("Name", text: $profileViewModel.profileData.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.trailing, 5)
                    .onChange(of: profileViewModel.profileData.name) { _ in
                        profileViewModel.saveProfileData()
                    }
            }

            DatePicker("Birthdate", selection: $profileViewModel.profileData.dateOfBirth, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.leading, 5)
                .padding(.trailing, 5)
                .font(.body.bold())
                .onChange(of: profileViewModel.profileData.dateOfBirth) { _ in
                    profileViewModel.saveProfileData()
                }

        }
        .padding(.top, 10)
    }

    var allergensSection: some View {
        Section(header: SectionHeaderView(title: "Allergens")) {
            ForEach(0..<max(1, profileViewModel.numAllergens), id: \.self) { index in
                if index < profileViewModel.numAllergens {
                    HStack {
                        Picker("Select an Allergen", selection: $profileViewModel.profileData.allergens[index]) {
                            ForEach(commonAllergens, id: \.self) { allergen in
                                Text(allergen).tag(allergen)
                            }
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .padding(.bottom, 10)
                        .onChange(of: profileViewModel.profileData.allergens[index]) { newValue in
                            if !profileViewModel.profileData.allergens.contains(newValue) {
                                profileViewModel.profileData.allergens.append(newValue)
                                profileViewModel.saveProfileData()
                            }
                        }

                        Button(action: {
                            profileViewModel.removeSelectedAllergen(at: index)
                        }) {
                            Image(systemName: "minus.circle").foregroundColor(.red)
                        }
                    }
                }
            }
            Button(action: {
                profileViewModel.addNewAllergen()
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color.darkTeal)
                    Text("Add Allergen")
                }
            }
        }.padding(.top, 10)
    }



    var shareDataWithHealthToggle: some View {
        Toggle("Share Data with Apple Health", isOn: $profileViewModel.profileData.shareDataWithAppleHealth)
            .toggleStyle(SwitchToggleStyle(tint: Color.darkTeal))
            .onChange(of: profileViewModel.profileData.shareDataWithAppleHealth) { newValue in
                healthKitViewModel.healthRequest()
                profileViewModel.saveProfileData()
            }
    }

    var protectDataWithFaceID: some View {
        Toggle("Protect data with FaceID", isOn: $profileViewModel.profileData.useFaceID)
            .toggleStyle(SwitchToggleStyle(tint: Color.darkTeal))
            .onChange(of: profileViewModel.profileData.useFaceID) { newValue in
                profileViewModel.saveProfileData()
            }
    }

    var preferencesSection: some View {
        Section(header: Text("Preferences").font(.title3).bold()) {
            shareDataWithHealthToggle
            protectDataWithFaceID
        }.padding(.top, 10)
    }

    // MARK: Settings View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    personalInformationSection
                    Divider().padding()
                    allergensSection
                    Spacer()
                    Divider().padding()
                    preferencesSection
                    Spacer()
                }
                .padding()
            }
        }
        .onDisappear {
            profileViewModel.profileData.allergens = profileViewModel.profileData.allergens.filter { !$0.isEmpty }
            profileViewModel.saveProfileData()
        }
        .onAppear(perform: {
            profileViewModel.loadProfileData()
            doseViewModel.loadDoses()
        })
    }
}

// MARK: Preview
#Preview {
    SettingsView()
        .environmentObject(HealthKitViewModel())
        .environmentObject(ProfileViewModel())
}
