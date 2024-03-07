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

    @State private var isAddingOtherAllergen = false
    @State private var isAddingOtherAllergenEmoji = false
    @State private var otherAllergenName: String = ""
    @State private var otherAllergenEmoji: String = ""

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
                        VStack {
                            Picker("Select an Allergen", selection: $profileViewModel.profileData.allergens[index]) {
                                ForEach($profileViewModel.profileData.commonAllergens, id: \.self) { allergen in
                                    Text(allergen.wrappedValue).tag(allergen.wrappedValue)
                                }
                                Text("Other").tag("Other")
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .padding(.bottom, 10)
                            .onChange(of: profileViewModel.profileData.allergens[index]) { newValue in
                                if newValue == "Other" {
                                    isAddingOtherAllergen = true
                                } else if !profileViewModel.profileData.allergens.contains(newValue) && newValue != "Select an Allergen" && newValue != "" && newValue != "Other"{
                                    profileViewModel.profileData.allergens.append(newValue)
                                    profileViewModel.profileData.allergens.removeAll { $0 == "Other" }
                                    profileViewModel.saveProfileData()
                                }
                            }
                            .onAppear {
                                if profileViewModel.profileData.allergens[index].isEmpty,
                                   let firstCommonAllergen = $profileViewModel.profileData.commonAllergens.first {
                                    profileViewModel.profileData.allergens[index] = firstCommonAllergen.wrappedValue
                                }
                            }
                            Spacer()
                        }

                        VStack {
                            Button(action: {
                                profileViewModel.removeSelectedAllergen(at: index)
                            }) {
                                Image(systemName: "minus.circle").foregroundColor(.red)
                                    .padding(.top, 7)
                            }
                            Spacer()
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
        }
        .padding(.top, 10)
        .alert("Enter Other Allergen", isPresented: $isAddingOtherAllergen) {
            TextField("Other Allergen", text: $otherAllergenName)
            Button("OK", action: submitOtherAllergen)
        }
        .alert("Enter Emoji for Your Allergen", isPresented: $isAddingOtherAllergenEmoji) {
            TextField("Emoji", text: $otherAllergenEmoji)
            Button("OK", action: submitOtherEmoji)
        }
    }

    func submitOtherAllergen() {
        if !profileViewModel.profileData.allergens.contains(otherAllergenName) {
            profileViewModel.profileData.allergens.append(otherAllergenName)
            profileViewModel.profileData.commonAllergens.append(otherAllergenName)
            profileViewModel.profileData.allergens.removeAll { $0 == "Other" }
            profileViewModel.saveProfileData()
        }
        isAddingOtherAllergen = false
        isAddingOtherAllergenEmoji = true
    }

    func submitOtherEmoji() {
        profileViewModel.profileData.allergenEmojiMap[otherAllergenName] = otherAllergenEmoji
        profileViewModel.saveProfileData()
        isAddingOtherAllergenEmoji = false
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
