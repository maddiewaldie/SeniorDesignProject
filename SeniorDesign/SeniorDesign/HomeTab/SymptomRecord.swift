import SwiftUI

struct SymptomRecord {
    let date: Date
    var symptoms: [String]

    init(date: Date, symptoms: [String]) {
        self.date = date
        self.symptoms = symptoms
    }
}

class SymptomDataManager: ObservableObject {
    @Published var symptomRecords: [Date: [String]] = [:]

    func saveSymptoms(for date: Date, symptoms: [String]) {
        symptomRecords[date] = symptoms
    }
}
