//
//  HealthKitViewModel.swift
//  SeniorDesign
//
//  Created by Maddie on 10/19/23.
//

import Foundation
import HealthKit

class HealthKitViewModel: ObservableObject {
    // MARK: Variables
    @Published var isAuthorized = false
    @Published var doseRecords: [Date: DoseRecord] = [:]
    private var healthStore = HKHealthStore()
    private var healthKitManager = HealthKitManager()

    // MARK: Initializer
    init() {
        changeAuthorizationStatus()
    }

    // MARK: Dose Functions
    func saveDoseRecord(_ doseRecord: DoseRecord) {
        doseRecords[doseRecord.date] = doseRecord
    }

    //MARK: - HealthKit Authorization Request Methods
    func healthRequest() {
        healthKitManager.setUpHealthRequest(healthStore: healthStore) {
            self.changeAuthorizationStatus()
        }
    }

    func changeAuthorizationStatus() {
        guard let stepQtyType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let status = self.healthStore.authorizationStatus(for: stepQtyType)

        switch status {
        case .notDetermined:
            isAuthorized = false
        case .sharingDenied:
            isAuthorized = false
        case .sharingAuthorized:
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        @unknown default:
            isAuthorized = false
        }
    }
}
