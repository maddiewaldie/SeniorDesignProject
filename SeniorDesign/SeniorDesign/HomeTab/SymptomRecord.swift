import SwiftUI
import CoreData

class SymptomDataManager: ObservableObject {
    @Published var symptomRecords: [Date: [String]] = [:]

    func saveSymptoms(for date: Date, symptoms: [String]) {
        // Update the symptom records dictionary with the new symptoms for the given date
        symptomRecords[date] = symptoms

        let context = persistentContainer.viewContext
        let symptomRecord = SymptomRecord(context: context)
        symptomRecord.date = date
        symptomRecord.symptoms = symptoms as NSObject

        do {
            try context.save()
        } catch {
            print("Failed to save symptoms: \(error.localizedDescription)")
        }
    }

    func fetchSymptoms(for date: Date) -> [String] {
        if let symptoms = symptomRecords[date] {
            // Return symptoms from the dictionary if available
            return symptoms
        } else {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<SymptomRecord> = SymptomRecord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)

            do {
                let result = try context.fetch(fetchRequest)
                if let record = result.first {
                    if let fetchedSymptoms = record.symptoms as? [String] {
                        // Update the symptom records dictionary with the fetched symptoms for caching
                        symptomRecords[date] = fetchedSymptoms
                        return fetchedSymptoms
                    }
                }
            } catch {
                print("Failed to fetch symptoms: \(error.localizedDescription)")
            }
        }
        return []
    }

    // Rest of the Core Data stack and persistent container remains the same...
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SymptomDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        return container
    }()
}
