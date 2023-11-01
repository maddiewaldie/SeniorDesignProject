//
//  DosingPopUp.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI

struct DosingPopUp: View {
    @State private var doseTime = Date()
    @State private var notes = ""
    @State private var allergens = [["Peanut", false, "🥜"], ["Egg", false, "🍳"], ["Milk", false, "🥛"]]
    @State private var antihistamines: [String] = ["Benadryl", "Pepcid", "Zyrtec", "Other"]
    @State private var hidden: [Bool] = [true, true, true, true]
    @State private var dose: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Allergens")
                        .font(.headline)
                        .padding()
                    Spacer()
                }

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<allergens.count) { allergen in
                            Button(action: {
                                allergens[allergen][1] = !(allergens[allergen][1] as! Bool)
                            }) {
                                VStack {
                                    Text(allergens[allergen][2] as! String)
                                        .padding(.bottom, 10)
                                        .font(.title)
                                    Text(allergens[allergen][0] as! String)
                                        .bold()
                                        .foregroundColor(allergens[allergen][1] as! Bool ? .white : .black)
                                }
                                .frame(width: 80, height: 100)
                                .padding()
                                .background(allergens[allergen][1] as! Bool ? Color.darkTeal : Color.lightTeal)
                                .cornerRadius(20)
                            }
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
                    Text("Dosage")
                        .font(.headline)
                        .padding()
                    Spacer()
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
        }
    }
}

#Preview {
    DosingPopUp()
}
