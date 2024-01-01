//
//  HealthKitManager.swift
//  SeniorDesign
//
//  Created by Maddie on 10/19/23.
//

import Foundation
import HealthKit

class HealthKitManager {

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

    func setUpHealthRequest(healthStore: HKHealthStore, readSteps: @escaping () -> Void) {

        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: Set(symptoms),
                                             read: []) { success, error in
                if success {
                } else if error != nil {
                    print(error ?? "Error")
                }
            }
        }
    }
}
