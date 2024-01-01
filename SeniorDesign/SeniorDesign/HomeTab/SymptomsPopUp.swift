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

    init(selectedSymptoms: Binding<Set<String>>, selectedDate: Date) {
            self._selectedSymptoms = selectedSymptoms
            self.selectedDate = selectedDate
        }

    let symptoms: [HKSampleType] = [
            HKObjectType.categoryType(forIdentifier: .abdominalCramps)!,
            HKObjectType.categoryType(forIdentifier: .bloating)!,
            HKObjectType.categoryType(forIdentifier: .constipation)!,
            HKObjectType.categoryType(forIdentifier: .diarrhea)!,
            HKObjectType.categoryType(forIdentifier: .heartburn)!,
            HKObjectType.categoryType(forIdentifier: .nausea)!,
            HKObjectType.categoryType(forIdentifier: .vomiting)!,
            HKObjectType.categoryType(forIdentifier: .appetiteChanges)!,
            HKObjectType.categoryType(forIdentifier: .chills)!,
            HKObjectType.categoryType(forIdentifier: .dizziness)!,
            HKObjectType.categoryType(forIdentifier: .fainting)!,
            HKObjectType.categoryType(forIdentifier: .fatigue)!,
            HKObjectType.categoryType(forIdentifier: .fever)!,
            HKObjectType.categoryType(forIdentifier: .generalizedBodyAche)!,
            HKObjectType.categoryType(forIdentifier: .hotFlashes)!,
            HKObjectType.categoryType(forIdentifier: .chestTightnessOrPain)!,
            HKObjectType.categoryType(forIdentifier: .coughing)!,
            HKObjectType.categoryType(forIdentifier: .rapidPoundingOrFlutteringHeartbeat)!,
            HKObjectType.categoryType(forIdentifier: .shortnessOfBreath)!,
            HKObjectType.categoryType(forIdentifier: .skippedHeartbeat)!,
            HKObjectType.categoryType(forIdentifier: .wheezing)!,
            HKObjectType.categoryType(forIdentifier: .lowerBackPain)!,
            HKObjectType.categoryType(forIdentifier: .headache)!,
            HKObjectType.categoryType(forIdentifier: .memoryLapse)!,
            HKObjectType.categoryType(forIdentifier: .moodChanges)!,
            HKObjectType.categoryType(forIdentifier: .lossOfSmell)!,
            HKObjectType.categoryType(forIdentifier: .lossOfTaste)!,
            HKObjectType.categoryType(forIdentifier: .runnyNose)!,
            HKObjectType.categoryType(forIdentifier: .soreThroat)!,
            HKObjectType.categoryType(forIdentifier: .sinusCongestion)!,
            HKObjectType.categoryType(forIdentifier: .acne)!,
            HKObjectType.categoryType(forIdentifier: .drySkin)!,
            HKObjectType.categoryType(forIdentifier: .hairLoss)!,
            HKObjectType.categoryType(forIdentifier: .nightSweats)!,
            HKObjectType.categoryType(forIdentifier: .sleepChanges)!,
            HKObjectType.categoryType(forIdentifier: .bladderIncontinence)!,
        ]

    let symptomEmojis: [String: String] = [
        "HKCategoryTypeIdentifierAbdominalCramps": "🤢",
        "HKCategoryTypeIdentifierBloating": "😣",
        "HKCategoryTypeIdentifierConstipation": "💩",
        "HKCategoryTypeIdentifierDiarrhea": "💩",
        "HKCategoryTypeIdentifierHeartburn": "🔥",
        "HKCategoryTypeIdentifierNausea": "🤢",
        "HKCategoryTypeIdentifierVomiting": "🤮",
        "HKCategoryTypeIdentifierAppetiteChanges": "🍽️",
        "HKCategoryTypeIdentifierChills": "🥶",
        "HKCategoryTypeIdentifierDizziness": "😵",
        "HKCategoryTypeIdentifierFainting": "😵‍💫",
        "HKCategoryTypeIdentifierFatigue": "😴",
        "HKCategoryTypeIdentifierFever": "🤒",
        "HKCategoryTypeIdentifierGeneralizedBodyAche": "🤕",
        "HKCategoryTypeIdentifierHotFlashes": "🥵",
        "HKCategoryTypeIdentifierChestTightnessOrPain": "💔",
        "HKCategoryTypeIdentifierCoughing": "🤧",
        "HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat": "💓",
        "HKCategoryTypeIdentifierShortnessOfBreath": "🫁",
        "HKCategoryTypeIdentifierSkippedHeartbeat": "💔",
        "HKCategoryTypeIdentifierWheezing": "🫁",
        "HKCategoryTypeIdentifierLowerBackPain": "🦵",
        "HKCategoryTypeIdentifierHeadache": "🤕",
        "HKCategoryTypeIdentifierMemoryLapse": "🧠",
        "HKCategoryTypeIdentifierMoodChanges": "😡",
        "HKCategoryTypeIdentifierLossOfSmell": "👃",
        "HKCategoryTypeIdentifierLossOfTaste": "👅",
        "HKCategoryTypeIdentifierRunnyNose": "🤧",
        "HKCategoryTypeIdentifierSoreThroat": "🤒",
        "HKCategoryTypeIdentifierSinusCongestion": "😤",
        "HKCategoryTypeIdentifierAcne": "🤕",
        "HKCategoryTypeIdentifierDrySkin": "🥵",
        "HKCategoryTypeIdentifierHairLoss": "👴",
        "HKCategoryTypeIdentifierNightSweats": "🌙",
        "HKCategoryTypeIdentifierSleepChanges": "😴",
        "HKCategoryTypeIdentifierBladderIncontinence": "🚽"
    ]


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
                ForEach(symptoms, id: \.self) { symptom in
                    Button(action: {
                        toggleSymptom(symptom.identifier.description)
                    }) {
                        VStack {
                            Text(formatSymptomName(symptom.identifier.description))
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 14))
                                .foregroundColor(selectedSymptoms.contains(symptom.identifier.description) ? Color.white : Color.black)
                            if let emoji = symptomEmojis[symptom.identifier.description] {
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
