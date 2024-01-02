//
//  HealthKitManager.swift
//  SeniorDesign
//
//  Created by Maddie on 10/19/23.
//

import Foundation
import HealthKit

class HealthKitManager {
    // MARK: Symptoms Array
    public let symptoms: [HKSampleType] = [
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

    // MARK: Symptom Functions
    func saveSymptom(_ symptom: String, for date: Date) {
        guard let symptomType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: symptom)) else {
            // TODO: Handle failure to get the symptom type
            return
        }
        
        let sample = HKCategorySample(type: symptomType, value: HKCategoryValue.notApplicable.rawValue, start: date, end: date)
        healthStore.save(sample) { success, error in
            if let error = error {
                print("Error saving symptom data: \(error.localizedDescription)")
            } else {
                print("Symptom data saved successfully")
            }
        }
    }
    
    func fetchSymptomsForDate(_ date: Date, completion: @escaping ([String]) -> Void) {
        var symptomsData: [String] = []
        for symptom in symptoms {
            let predicate = HKQuery.predicateForSamples(withStart: date, end: date, options: .strictStartDate)
            let query = HKSampleQuery(sampleType: symptom, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                if let error = error {
                    print("Error fetching symptom data: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                if let samples = samples as? [HKCategorySample] {
                    for sample in samples {
                        symptomsData.append(sample.categoryType.identifier)
                    }
                }
            }
            healthStore.execute(query)
        }
        completion(symptomsData)
    }
    
    func loadSymptomsForSelectedDate(selectedDate: Date, symptomDataManager: SymptomDataManager, completion: @escaping () -> Void) {
        fetchSymptomsForDate(selectedDate) { symptoms in
            symptomDataManager.symptomRecords[selectedDate] = symptoms
            completion()
        }
    }

    // MARK: Health Request Functions
    func setUpHealthRequest(healthStore: HKHealthStore, readSteps: @escaping () -> Void) {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: Set(symptoms), read: []) { success, error in
                if success {
                } else if error != nil {
                    print(error ?? "Error")
                }
            }
        }
    }
}
