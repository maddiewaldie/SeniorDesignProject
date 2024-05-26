import HealthKit
import SwiftUI

struct SymptomsPopUp: View {
    // MARK: Variables
    @EnvironmentObject var symptomDataManager: SymptomDataManager
    @Binding var selectedSymptoms: Set<String>
    let selectedDate: Date
    @State var contactDoctor = false
    let healthKitManager = HealthKitManager()
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    // MARK: Initializer
    init(selectedSymptoms: Binding<Set<String>>, selectedDate: Date) {
        self._selectedSymptoms = selectedSymptoms
        self.selectedDate = selectedDate
    }

    private func foregroundColor(for symptom: HKSampleType) -> Color {
        if selectedSymptoms.contains(symptom.identifier.description) {
            return colorScheme == .light ? Color.white : Color.white
        } else {
            return colorScheme == .light ? Color.black : Color.black
        }
    }

    private func backgroundColor(for symptom: HKSampleType) -> Color {
        if selectedSymptoms.contains(symptom.identifier.description) {
            return colorScheme == .light ? Color.darkTeal : Color.darkerTeal
        } else {
            return colorScheme == .light ? Color.lightTeal : Color.darkTeal
        }
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
                                .font(.system(size: 14)).bold()
                                .foregroundColor(foregroundColor(for: symptom))
                            if let emoji = healthKitManager.symptomEmojis[symptom.identifier.description] {
                                if healthKitManager.symptomImageNeeded(symptom.identifier.description) {
                                    Image("\(symptom.identifier.description)")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.top, 10)
                                } else {
                                    Text(emoji)
                                        .font(.largeTitle).bold()
                                        .padding(.top, 5)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width/3 - 10, height: 150)
                        .background(backgroundColor(for: symptom))
                        .cornerRadius(20)
                    }
                }
            }
        }
        .alert("Have you contacted your doctor? 🩺", isPresented: $contactDoctor) {
            Text("You have selected symptoms that may require immediate attention. Please contact your doctor or call 911.")
            Button("OK", action: {contactDoctor = false})
        }
        .onDisappear(perform: saveSymptomsForSelectedDate)
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

        let worrisomeSymptoms = ["HKCategoryTypeIdentifierFever", "HKCategoryTypeIdentifierVomiting", "HKCategoryTypeIdentifierChestTightnessOrPain", "HKCategoryTypeIdentifierChills", "HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat", "HKCategoryTypeIdentifierShortnessOfBreath", "HKCategoryTypeIdentifierMemoryLapse", "HKCategoryTypeIdentifierMoodChanges", "HKCategoryTypeIdentifierFainting", "HKCategoryTypeIdentifierDizziness", "HKCategoryTypeIdentifierCoughing"]

            let hasWorrisomeSymptoms = selectedSymptoms.contains { worrisomeSymptoms.contains($0) }

            if hasWorrisomeSymptoms {
                contactDoctor = true
            }
    }

    private func toggleSymptom(_ identifier: String) {
        if selectedSymptoms.contains(identifier) {
            selectedSymptoms.remove(identifier)
        } else {
            selectedSymptoms.insert(identifier)
        }
    }
}
