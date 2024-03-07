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
    
    // Function to fetch all stored symptoms from Core Data
    func fetchAllSymptoms() -> [String] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SymptomRecord> = SymptomRecord.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            let allSymptoms = result.flatMap { ($0.symptoms as? [String]) ?? [] }
            return allSymptoms
        } catch {
            print("Failed to fetch all symptoms: \(error.localizedDescription)")
            return []
        }
    }


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SymptomDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        return container
    }()

    func lastReactionDate() -> Date? {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<SymptomRecord> = SymptomRecord.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.fetchLimit = 1

            do {
                let result = try context.fetch(fetchRequest)
                if let record = result.first {
                    return record.date
                }
            } catch {
                print("Failed to fetch last reaction date: \(error.localizedDescription)")
            }

            return nil
        }
}
