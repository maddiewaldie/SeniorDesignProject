//
//  HealthKitManager.swift
//  SeniorDesign
//
//  Created by Maddie on 10/19/23.
//

import Foundation
import HealthKit

class HealthKitManager {

    func setUpHealthRequest(healthStore: HKHealthStore, readSteps: @escaping () -> Void) {
        // To Share:
        // Abdominal and Gastrointestinal
        let abdominalCramps = HKCategoryType(HKCategoryTypeIdentifier.abdominalCramps)
        let bloating = HKCategoryType(HKCategoryTypeIdentifier.bloating)
        let constipation = HKCategoryType(HKCategoryTypeIdentifier.constipation)
        let diarrhea = HKCategoryType(HKCategoryTypeIdentifier.diarrhea)
        let heartburn = HKCategoryType(HKCategoryTypeIdentifier.heartburn)
        let nausea = HKCategoryType(HKCategoryTypeIdentifier.nausea)
        let vomiting = HKCategoryType(HKCategoryTypeIdentifier.vomiting)
        // Constitutional
        let appetiteChanges = HKCategoryType(HKCategoryTypeIdentifier.appetiteChanges)
        let chills = HKCategoryType(HKCategoryTypeIdentifier.chills)
        let dizziness = HKCategoryType(HKCategoryTypeIdentifier.dizziness)
        let fainting = HKCategoryType(HKCategoryTypeIdentifier.fainting)
        let fatigue = HKCategoryType(HKCategoryTypeIdentifier.fatigue)
        let fever = HKCategoryType(HKCategoryTypeIdentifier.fever)
        let generalizedBodyAche = HKCategoryType(HKCategoryTypeIdentifier.generalizedBodyAche)
        let hotFlashes = HKCategoryType(HKCategoryTypeIdentifier.hotFlashes)
        // Heart and Lung
        let chestTightnessOrPain = HKCategoryType(HKCategoryTypeIdentifier.chestTightnessOrPain)
        let coughing = HKCategoryType(HKCategoryTypeIdentifier.coughing)
        let rapidPoundingOrFlutteringHeartbeat = HKCategoryType(HKCategoryTypeIdentifier.rapidPoundingOrFlutteringHeartbeat)
        let shortnessOfBreath = HKCategoryType(HKCategoryTypeIdentifier.shortnessOfBreath)
        let skippedHeartbeat = HKCategoryType(HKCategoryTypeIdentifier.skippedHeartbeat)
        let wheezing = HKCategoryType(HKCategoryTypeIdentifier.wheezing)
        // Musculoskeletal
        let lowerBackPain = HKCategoryType(HKCategoryTypeIdentifier.lowerBackPain)
        // Neurological
        let headache = HKCategoryType(HKCategoryTypeIdentifier.headache)
        let memoryLapse = HKCategoryType(HKCategoryTypeIdentifier.memoryLapse)
        let moodChanges = HKCategoryType(HKCategoryTypeIdentifier.moodChanges)
        // Nose and Throat
        let lossOfSmell = HKCategoryType(HKCategoryTypeIdentifier.lossOfSmell)
        let lossOfTaste = HKCategoryType(HKCategoryTypeIdentifier.lossOfTaste)
        let runnyNose = HKCategoryType(HKCategoryTypeIdentifier.runnyNose)
        let soreThroat = HKCategoryType(HKCategoryTypeIdentifier.soreThroat)
        let sinusCongestion = HKCategoryType(HKCategoryTypeIdentifier.sinusCongestion)
        // Skin and Hair
        let acne = HKCategoryType(HKCategoryTypeIdentifier.acne)
        let drySkin = HKCategoryType(HKCategoryTypeIdentifier.drySkin)
        let hairLoss = HKCategoryType(HKCategoryTypeIdentifier.hairLoss)
        // Sleep
        let nightSweats = HKCategoryType(HKCategoryTypeIdentifier.nightSweats)
        let sleepChanges = HKCategoryType(HKCategoryTypeIdentifier.sleepChanges)
        // Urinary
        let bladderIncontinence = HKCategoryType(HKCategoryTypeIdentifier.bladderIncontinence)

        // To Read:

        // Menstrual

        // Heart Rate

        // Sleep

        // Exercise

        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: [abdominalCramps, bloating, constipation, diarrhea,
                                                       heartburn, nausea, vomiting, appetiteChanges,
                                                       chills, dizziness, fainting, fatigue, fever, generalizedBodyAche,
                                                       hotFlashes, chestTightnessOrPain, coughing, rapidPoundingOrFlutteringHeartbeat,
                                                       shortnessOfBreath, skippedHeartbeat, wheezing, lowerBackPain,
                                                       headache, memoryLapse, moodChanges, lossOfSmell, lossOfTaste, runnyNose,
                                                       soreThroat, sinusCongestion, acne, drySkin, hairLoss, nightSweats, sleepChanges,
                                                       bladderIncontinence],
                                             read: []) { success, error in
                if success {
                } else if error != nil {
                    print(error ?? "Error")
                }
            }
        }
    }
}
