import HealthKit
import SwiftUI

struct SymptomsPopUp: View {
    // MARK: Variables
    @EnvironmentObject var symptomDataManager: SymptomDataManager
    @Binding var selectedSymptoms: Set<String>
    let selectedDate: Date
    let healthKitManager = HealthKitManager()
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    // MARK: Initializer
    init(selectedSymptoms: Binding<Set<String>>, selectedDate: Date) {
        self._selectedSymptoms = selectedSymptoms
        self.selectedDate = selectedDate
    }

    // MARK: Symptoms Pop Up View
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(healthKitManager.symptoms, id: \.self) { symptom in
                    Button(action: {
                        toggleSymptom(symptom.identifier.description)
                    }) {
                        VStack {
                            Text(formatSymptomName(symptom.identifier.description))
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 14))
                                .foregroundColor(selectedSymptoms.contains(symptom.identifier.description) ? Color.white : Color.black)
                            if let emoji = healthKitManager.symptomEmojis[symptom.identifier.description] {
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

    // MARK: Functions
    private func formatSymptomName(_ identifier: String) -> String {
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

    private func saveSymptomsForSelectedDate() {
        symptomDataManager.saveSymptoms(for: selectedDate, symptoms: Array(selectedSymptoms))
    }

    private func toggleSymptom(_ identifier: String) {
        if selectedSymptoms.contains(identifier) {
            selectedSymptoms.remove(identifier)
        } else {
            selectedSymptoms.insert(identifier)
        }
    }
}
