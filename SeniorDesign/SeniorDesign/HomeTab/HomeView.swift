//
//  HomeView.swift
//  SeniorDesign
//
//  Created by Maddie on 8/20/23.
//

import SwiftUI

struct HomeView: View {
    // MARK: View Models
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @EnvironmentObject var doseViewModel: DoseViewModel
    @EnvironmentObject var profileImageViewModel: ProfileModel

    let healthKitManager = HealthKitManager()

    // MARK: Variables
    @State private var selectedDate = Date()
    @State private var selectedColorIndex: Int?
    @State private var weekView = true
    @State private var logSymptoms = false
    @State private var logDose = false
    @State private var selectedSymptoms: Set<String> = []
    @State private var dayOfTreatment = 1 // Initial value
    @ObservedObject var symptomDataManager = SymptomDataManager()
    var symptomsForSelectedDate: [String] {
        return symptomDataManager.fetchSymptoms(for: selectedDate)
    }


    // MARK: UI Elements
    var profileButton: some View {
        NavigationLink(destination: SettingsView().environmentObject(profileViewModel)
            .environmentObject(healthKitViewModel).environmentObject(profileImageViewModel)) {

                CircularProfileImage(imageState: profileImageViewModel.imageState)
                    .frame(width: 35, height: 35)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 16)
    }

    var monthCalendarButton: some View {
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

    var header: some View {
        HStack {
            profileButton
            Spacer()
            monthCalendarButton
        }
    }

    var weekScrollView: some View {
        WeeklyScrollCalendarView
            .padding(.bottom, -10)
            .onAppear {
                selectedDate = startOfWeek
            }
            .onChange(of: selectedDate) { _ in
                dayOfTreatment = calculateDayOfTreatment()
            }
    }

    var weekCircleView: some View {
        Circle()
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 10)
            .foregroundColor(.lightTeal)
            .overlay(
                weekCircleViewContent
            )
    }

    var weekCircleViewContent: some View {
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
                    .environmentObject(doseViewModel)
            }
            .padding()
        }
    }

    var monthCalendarView: some View {
        DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .tint(.darkTeal)
    }

    var logSymptomsButton: some View {
        Button(action: {
            logSymptoms.toggle()
            selectedSymptoms = Set(symptomDataManager.fetchSymptoms(for: selectedDate))
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
                            .environmentObject(symptomDataManager) // Pass SymptomDataManager here
                    }
                }
    }

    var symptomsScrollView: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 10) {
                        logSymptomsButton
                        ForEach(Array(symptomsForSelectedDate), id: \.self) { symptom in
                            Button(action: {}) {
                                VStack {
                                    Text(formatSymptomName(symptom))
                                        .foregroundColor(.black)
                                        .padding(.bottom, 10)
                                    if let emoji = healthKitManager.symptomEmojis[symptom] {
                                        Text(emoji)
                                            .font(.largeTitle)
                                            .padding(.top, 5)
                                    }
                                }
                                .frame(width: 130, height: 150)
                                .background(Color.lightTeal)
                                .cornerRadius(20)
                            }
                            .id(symptom)
                        }
                    }
                }
            }
        }
        .padding()
    }

    // MARK: Home Tab View
    var body: some View {
        NavigationView {
            VStack {
                header
                VStack {
                    if weekView {
                        weekScrollView
                    }
                    ScrollView {
                        if weekView {
                            weekCircleView
                        } else {
                            monthCalendarView
                        }
                        if let dose = healthKitViewModel.doseRecords[selectedDate] {
                            if dose.doses != nil {
                                AboutYourDoseView(allergenDoses: dose)
                            }
                        }
                        symptomsScrollView
                    }
                }
            }
        }
        .onAppear(perform: {
            profileViewModel.loadProfileData()
//            profileViewModel.profileData.commonAllergens = ["Milk", "Eggs", "Fish", "Shellfish", "Soy", "Peanuts", "Almonds", "Brazil Nuts", "Cashews", "Coconuts", "Hazelnuts", "Macadamia Nuts", "Pecans", "Pine Nuts", "Pistachios", "Walnuts", "Wheat", "Sesame"]
            healthKitManager.loadSymptomsForSelectedDate(selectedDate: selectedDate, symptomDataManager: symptomDataManager) {
            }
            _ = healthKitViewModel.fetchSymptomsFromCoreData(for: selectedDate)
            healthKitViewModel.fetchDoseRecords()
            doseViewModel.loadDoses()
            profileImageViewModel.loadProfileImage()
        })
        
        Spacer()
    }

    // MARK: Symptom Functions
    private func saveSymptomsForSelectedDate() {
        symptomDataManager.saveSymptoms(for: selectedDate, symptoms: Array(selectedSymptoms))
    }

    private func saveHKSymptomsForSelectedDate() {
        for symptom in selectedSymptoms {
            healthKitManager.saveSymptom(symptom, for: selectedDate)
        }
    }

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

    // MARK: Week View Functions
    private var WeeklyScrollCalendarView: some View {
        VStack {
            VStack {
                HStack(alignment: .center, spacing: 14) {
                    ForEach(0..<7, id: \.self) { index in
                        let day = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek)!
                        CalendarDayView(selectedDate: $selectedDate, selectedColorIndex: $selectedColorIndex, date: day,  index: index)
                    }
                }
            }
            .padding()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { value in
                let weekInterval: TimeInterval = 60 * 60 * 24 * 7
                let startOfNextWeekDate = startOfNextWeek(from: startOfWeek)
                if value.translation.width > 50 {
                    selectedDate = selectedDate.addingTimeInterval(-weekInterval)
                } else if value.translation.width < -50 && startOfNextWeekDate < Date() {
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

    private func startOfNextWeek(from date: Date) -> Date {
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: date)
        if let currentWeekStartDate = calendar.date(from: startComponents) {
            startComponents.weekOfYear? += 1 // Increment to the next week
            return calendar.date(from: startComponents) ?? currentWeekStartDate
        }
        return date
    }

    private var monthHeader: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: startOfWeek)
    }

    // MARK: Day of Treatment Functions
    func calculateDayOfTreatment() -> Int {
        if let firstSymptomDate = symptomDataManager.symptomRecords.keys.sorted().first,
           let firstDoseDate = healthKitViewModel.doseRecords.keys.sorted().first {

            let firstDates = [firstSymptomDate, firstDoseDate]
            let minDate = firstDates.min()!

            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: minDate, to: selectedDate)
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        if let firstSymptomDate = symptomDataManager.symptomRecords.keys.sorted().first {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstSymptomDate, to: selectedDate)
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        if let firstDoseDate = healthKitViewModel.doseRecords.keys.sorted().first {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstDoseDate, to: selectedDate)
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        return 1
    }
}

// MARK: Preview
#Preview {
    HomeView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HealthKitViewModel())
}
