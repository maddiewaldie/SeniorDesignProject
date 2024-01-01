//
//  HomeView.swift
//  SeniorDesign
//
//  Created by Maddie on 8/20/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @State private var selectedDate = Date()
    @State private var selectedColorIndex: Int?
    @State private var weekView = true
    @State private var logSymptoms = false
    @State private var logDose = false
    @State private var selectedSymptoms: Set<String> = []
    @State private var dayOfTreatment = 1 // Initial value
    @ObservedObject var symptomDataManager = SymptomDataManager()
    var symptomsForSelectedDate: [String] {
        return symptomDataManager.symptomRecords[selectedDate] ?? []
    }

    func saveSymptomsForSelectedDate() {
        symptomDataManager.saveSymptoms(for: selectedDate, symptoms: Array(selectedSymptoms))
    }

    func calculateDayOfTreatment() -> Int {
        if let firstSymptomDate = symptomDataManager.symptomRecords.keys.sorted().first,
           let firstDoseDate = healthKitViewModel.doseRecords.keys.sorted().first {
            let firstDate = min(firstSymptomDate, firstDoseDate, selectedDate)

            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstDate, to: selectedDate)
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        return 1 // Default to 1 if no symptom or dose data is available
    }



    let symptomEmojis: [String: String] = [
        "HKCategoryTypeIdentifierAbdominalCramps": "🤢",
        "HKCategoryTypeIdentifierBloating": "😣",
        "HKCategoryTypeIdentifierConstipation": "💩",
        "HKCategoryTypeIdentifierDiarrhea": "💩",
        "HKCategoryTypeIdentifierHeartburn": "🔥",
        "HKCategoryTypeIdentifierNausea": "🤢",
        "HKCategoryTypeIdentifierVomiting": "🤮",
        "HKCategoryTypeIdentifierAppetiteChanges": "🍽️",
        "HKCategoryTypeIdentifierChills": "🥶",
        "HKCategoryTypeIdentifierDizziness": "😵",
        "HKCategoryTypeIdentifierFainting": "😵‍💫",
        "HKCategoryTypeIdentifierFatigue": "😴",
        "HKCategoryTypeIdentifierFever": "🤒",
        "HKCategoryTypeIdentifierGeneralizedBodyAche": "🤕",
        "HKCategoryTypeIdentifierHotFlashes": "🥵",
        "HKCategoryTypeIdentifierChestTightnessOrPain": "💔",
        "HKCategoryTypeIdentifierCoughing": "🤧",
        "HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat": "💓",
        "HKCategoryTypeIdentifierShortnessOfBreath": "🫁",
        "HKCategoryTypeIdentifierSkippedHeartbeat": "💔",
        "HKCategoryTypeIdentifierWheezing": "🫁",
        "HKCategoryTypeIdentifierLowerBackPain": "🦵",
        "HKCategoryTypeIdentifierHeadache": "🤕",
        "HKCategoryTypeIdentifierMemoryLapse": "🧠",
        "HKCategoryTypeIdentifierMoodChanges": "😡",
        "HKCategoryTypeIdentifierLossOfSmell": "👃",
        "HKCategoryTypeIdentifierLossOfTaste": "👅",
        "HKCategoryTypeIdentifierRunnyNose": "🤧",
        "HKCategoryTypeIdentifierSoreThroat": "🤒",
        "HKCategoryTypeIdentifierSinusCongestion": "😤",
        "HKCategoryTypeIdentifierAcne": "🤕",
        "HKCategoryTypeIdentifierDrySkin": "🥵",
        "HKCategoryTypeIdentifierHairLoss": "👴",
        "HKCategoryTypeIdentifierNightSweats": "🌙",
        "HKCategoryTypeIdentifierSleepChanges": "😴",
        "HKCategoryTypeIdentifierBladderIncontinence": "🚽"
    ]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: SettingsView().environmentObject(profileViewModel)
                        .environmentObject(healthKitViewModel)){
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 16)
                    Spacer()

                    HStack {
                        Text(monthHeader)
                            .font(.body)
                            .bold()
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 20)
                    }
                    .onTapGesture {
                        weekView.toggle()
                    }
                }
                VStack {
                    if weekView {
                        WeeklyScrollCalendarView
                            .padding(.bottom, -10)
                            .onAppear {
                                selectedDate = startOfWeek
                            }
                    }
                    ScrollView {
                        if weekView {
                            Circle()
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .padding(.bottom, 10)
                                .foregroundColor(Color.lightTeal)
                                .overlay(
                                    VStack {
                                        Text("Day")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .bold()
                                            .padding(.top, 30)
                                        Text("\(dayOfTreatment)")
                                            .font(.system(size: 70))
                                            .foregroundColor(.black)
                                            .bold()
                                        Text("of Treatment")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .bold()
                                        Button(action: {
                                            logDose.toggle()
                                        }) {
                                            Text("Log Dose         ")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                                .padding()
                                                .background(Color.darkTeal)
                                                .cornerRadius(30)
                                        }
                                        .sheet(isPresented: $logDose) {
                                            DosingPopUp(selectedDate: selectedDate)
                                        }
                                        .padding()
                                        .onAppear {
                                                    // Start a timer to update the day of treatment periodically (every second in this example)
                                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                                        // Calculate and update the day of treatment
                                                        dayOfTreatment = calculateDayOfTreatment()
                                                    }
                                                }
                                    }
                                )
                        } else {
                            DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .tint(Color.lightTeal)
                        }
                        if let dose = healthKitViewModel.doseRecords[selectedDate] {
                            AboutYourDoseView(allergenDoses: dose)
                        }
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { proxy in
                                    HStack(spacing: 10) {
                                        Button(action: {
                                            logSymptoms.toggle()
                                            selectedSymptoms = []
                                        }) {
                                            VStack {
                                                Text("Log your Symptoms")
                                                    .foregroundColor(.black)
                                                    .padding(.bottom, 20)
                                                Image(systemName: "plus")
                                                    .foregroundColor(.black)
                                            }
                                            .frame(width: 130, height: 150)
                                            .background(Color.lightTeal)
                                            .cornerRadius(20)
                                        }
                                        .sheet(isPresented: $logSymptoms) {
                                            NavigationView {
                                                SymptomsPopUp(selectedSymptoms: $selectedSymptoms, selectedDate: selectedDate)
                                                    .navigationBarItems(trailing: Button("Done") {
                                                        logSymptoms = false
                                                        saveSymptomsForSelectedDate()
                                                    })
                                            }
                                        }

                                        ForEach(Array(symptomsForSelectedDate), id: \.self) { symptom in
                                            Button(action: {
                                                // Handle tapping on a selected symptom if needed
                                            }) {
                                                VStack {
                                                    Text(formatSymptomName(symptom))
                                                        .foregroundColor(.black)
                                                        .padding(.bottom, 10)
                                                    if let emoji = symptomEmojis[symptom] {
                                                        Text(emoji)
                                                            .font(.largeTitle)
                                                            .padding(.top, 5)
                                                    }
                                                }
                                                .frame(width: 130, height: 150)
                                                .background(Color.lightTeal)
                                                .cornerRadius(20)
                                            }
                                            .id(symptom) // Assign an ID to scroll to the added symptom if needed
                                        }
                                    }
                                }
                            }
                        }
                        .padding()


                    }
                }
            }
        }

    }

    func formatSymptomName(_ identifier: String) -> String {
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

    var WeeklyScrollCalendarView: some View {
        VStack {
            VStack {
                HStack(alignment: .center, spacing: 14) {
                    ForEach(0..<7, id: \.self) { index in
                        let day = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek)!
                        CalendarDayView(date: day, selectedDate: $selectedDate, selectedColorIndex: $selectedColorIndex, index: index)
                    }
                }
            }
            .padding()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { value in
                let weekInterval: TimeInterval = 60 * 60 * 24 * 7
                if value.translation.width > 50 {
                    selectedDate = selectedDate.addingTimeInterval(-weekInterval)
                } else if value.translation.width < -50 {
                    selectedDate = selectedDate.addingTimeInterval(weekInterval)
                }
            }
        )
    }

    private var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
        var startComponents = DateComponents()
        startComponents.yearForWeekOfYear = components.yearForWeekOfYear
        startComponents.weekOfYear = components.weekOfYear
        startComponents.weekday = 1 // Sunday
        return calendar.date(from: startComponents)!
    }

    private var monthHeader: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: startOfWeek)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(ProfileViewModel())
                .environmentObject(HealthKitViewModel())
        }
    }
}
