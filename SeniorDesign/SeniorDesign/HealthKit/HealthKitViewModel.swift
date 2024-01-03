//
//  HealthKitViewModel.swift
//  SeniorDesign
//
//  Created by Maddie on 10/19/23.
//

import Foundation
import HealthKit
import CoreData

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
    // CoreData container
    public let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DoseDataModel")
        let antihistamineDoseTransformer = AntihistamineDoseTransformer()
        ValueTransformer.setValueTransformer(antihistamineDoseTransformer, forName: NSValueTransformerName(rawValue: "AntihistamineDoseTransformer"))

        let dosesTransformer = DosesTransformer()
        ValueTransformer.setValueTransformer(dosesTransformer, forName: NSValueTransformerName(rawValue: "DosesTransformer"))

        let selectedAllergensTransformer = SelectedAllergensTransformer()
        ValueTransformer.setValueTransformer(selectedAllergensTransformer, forName: NSValueTransformerName(rawValue: "SelectedAllergensTransformer"))
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        })
        return container
    }()

    // Function to save dose record using CoreData
    func saveDoseRecord(_ doseRecord: DoseRecord) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "DoseRecordEntity", in: context) else { return }

        let doseRecordEntity = NSManagedObject(entity: entity, insertInto: context)
        doseRecordEntity.setValue(doseRecord.date, forKey: "date")
        // Set other properties similarly

        do {
            try context.save()
        } catch {
            print("Failed to save dose record: \(error.localizedDescription)")
        }
    }

    // Function to fetch dose records using CoreData
    func fetchDoseRecords() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DoseRecord>(entityName: "DoseRecord")

        do {
            let fetchedRecords = try context.fetch(fetchRequest)
            // Create a dictionary to store fetched dose records by date
            var doseRecordsByDate: [Date: DoseRecord] = [:]

            // Map fetched dose records to a dictionary using the date as the key
            for record in fetchedRecords {
                doseRecordsByDate[record.date!] = record
            }

            // Update the doseRecords dictionary with fetched dose records
            self.doseRecords = doseRecordsByDate
        } catch {
            print("Failed to fetch dose records: \(error.localizedDescription)")
        }
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

    func saveSymptomsToCoreData(for date: Date, symptoms: [String]) {
            let symptomDataManager = SymptomDataManager()
            symptomDataManager.saveSymptoms(for: date, symptoms: symptoms)
        }

        func fetchSymptomsFromCoreData(for date: Date) -> [String] {
            let symptomDataManager = SymptomDataManager()
            return symptomDataManager.fetchSymptoms(for: date)
        }
}
