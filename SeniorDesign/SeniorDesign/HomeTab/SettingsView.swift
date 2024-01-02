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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var vm: HealthKitViewModel
    
    let commonAllergens = ["Peanuts", "Milk", "Eggs", "Fish", "Shellfish", "Soy", "Tree Nuts", "Almonds", "Brazil Nuts", "Cashews", "Hazelnuts", "Macadamia Nuts", "Pecans", "Pine Nuts", "Pistachios", "Walnuts", "Wheat", "Sesame"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
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
                    
                    Divider().padding()
                    
                    Section(header: SectionHeaderView(title: "Allergens")) {
                        ForEach(profileViewModel.allergens.indices, id: \.self) { index in
                            HStack {
                                Picker("Select an Allergen", selection: $profileViewModel.allergens[index]) {
                                    ForEach(commonAllergens, id: \.self) { allergen in
                                        Text(allergen).tag(allergen)
                                    }
                                    Text("Other").tag("Other")
                                }
                                .pickerStyle(DefaultPickerStyle())
                                .padding(.bottom, 10)
                                .onChange(of: profileViewModel.allergens[index]) { newValue in
                                    // Check if the new value already exists in the list before appending
                                    if !profileViewModel.profileData.allergens.contains(newValue) {
                                        profileViewModel.profileData.allergens.append(newValue)
                                        profileViewModel.saveProfileData()
                                    }
                                }
                                
                                Button(action: {
                                    profileViewModel.removeSelectedAllergen(at: index)
                                    profileViewModel.saveProfileData()
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Button(action: {
                            profileViewModel.profileData.allergens.append("Peanuts")
                            profileViewModel.allergens.append("Peanuts")
                            profileViewModel.saveProfileData()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(Color.darkTeal)
                                Text("Add Allergen")
                            }
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
                    
                    Divider()
                        .padding()
                    
                    Section(header: Text("Preferences").font(.title3).bold()) {
                        Toggle("Share Data with Apple Health", isOn: $profileViewModel.profileData.shareDataWithAppleHealth)
                            .toggleStyle(SwitchToggleStyle(tint: Color.darkTeal))
                            .onChange(of: profileViewModel.profileData.shareDataWithAppleHealth) { newValue in
                                vm.healthRequest()
                                profileViewModel.saveProfileData()
                            }
                        
                        Toggle("Protect data with FaceID", isOn: $profileViewModel.profileData.useFaceID)
                            .toggleStyle(SwitchToggleStyle(tint: Color.darkTeal))
                            .onChange(of: profileViewModel.profileData.useFaceID) { newValue in
                                profileViewModel.saveProfileData()
                            }
                    }
                    .padding(.top, 10)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    Spacer()
                }
                .padding()
            }
        }
        .onDisappear {
            profileViewModel.profileData.allergens = profileViewModel.allergens.filter { !$0.isEmpty }
            profileViewModel.saveProfileData()
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    SettingsView()
        .environmentObject(HealthKitViewModel())
        .environmentObject(ProfileViewModel())
}
