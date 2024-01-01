//
//  HealthKitViewModel.swift
//  SeniorDesign
//
//  Created by Maddie on 10/19/23.
//

import Foundation
import HealthKit

class HealthKitViewModel: ObservableObject {

    private var healthStore = HKHealthStore()
    private var healthKitManager = HealthKitManager()
    @Published var isAuthorized = false

    @Published var doseRecords: [Date: DoseRecord] = [:]
    func saveDoseRecord(_ doseRecord: DoseRecord) {
        doseRecords[doseRecord.date] = doseRecord
    }

    init() {
        changeAuthorizationStatus()
    }

    //MARK: - HealthKit Authorization Request Method
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
