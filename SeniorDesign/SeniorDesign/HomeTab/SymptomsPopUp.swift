//
//  SymptomsPopUp.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import HealthKit

struct SymptomsPopUp: View {
    
    @Binding var selectedSymptoms: Set<String>
    
    @ObservedObject var symptomDataManager = SymptomDataManager()
    let selectedDate: Date
    let healthKitManager = HealthKitManager()
    
    init(selectedSymptoms: Binding<Set<String>>, selectedDate: Date) {
        self._selectedSymptoms = selectedSymptoms
        self.selectedDate = selectedDate
    }
    
    func formatSymptomName(_ identifier: String) -> String {
        let trimmed = identifier.replacingOccurrences(of: "HKCategoryTypeIdentifier", with: "")
        var formatted = ""
        for char in trimmed {
            if char.isUppercase {
                formatted += " " + String(char)
            } else {
                formatted += String(char)
            }
        }
        return formatted.trimmingCharacters(in: .whitespaces)
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(healthKitManager.symptoms, id: \.self) { symptom in
                    Button(action: {
                        toggleSymptom(symptom.identifier.description)
                    }) {
                        VStack {
                            Text(formatSymptomName(symptom.identifier.description))
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 14))
                                .foregroundColor(selectedSymptoms.contains(symptom.identifier.description) ? Color.white : Color.black)
                            if let emoji = healthKitManager.symptomEmojis[symptom.identifier.description] {
                                Text(emoji)
                                    .font(.largeTitle)
                                    .padding(.top, 5)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width/3 - 10, height: 150)
                        .background(selectedSymptoms.contains(symptom.identifier.description) ? Color.darkTeal : Color.lightTeal)
                        .cornerRadius(20)
                    }
                }
            }
        }
        .padding(10)
    }
    
    func saveSymptomsForSelectedDate() {
        symptomDataManager.saveSymptoms(for: selectedDate, symptoms: Array(selectedSymptoms))
    }
    
    private func toggleSymptom(_ identifier: String) {
        if selectedSymptoms.contains(identifier) {
            selectedSymptoms.remove(identifier) // Deselect symptom if already selected
        } else {
            selectedSymptoms.insert(identifier) // Select symptom if not selected
        }
        
        // Print selected symptoms
        print("Selected symptoms: \(selectedSymptoms)")
    }
}
