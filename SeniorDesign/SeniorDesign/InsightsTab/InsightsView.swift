//
//  InsightsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import CoreData
import TipKit

struct InsightsView: View {
    // MARK: View Model
    @ObservedObject var healthKitViewModel: HealthKitViewModel
    @ObservedObject var symptomDataManager = SymptomDataManager()
    @State private var slicesWithLabels: [(Double, Color, String)] = []
    @Environment(\.colorScheme) var colorScheme

    var header: some View {
        HStack {
            Text("Insights")
                .font(.largeTitle.bold())
                .padding()
            Spacer()
        }
    }

    var insightsTip = InsightsTip()

    // MARK: Insights View
    var body: some View {
        VStack {
            header
            ScrollView {
                if #available(iOS 17.0, *) {
                    TipView(insightsTip, arrowEdge: .none)
                        .tipCornerRadius(15)
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .padding(.bottom, 20)
                }
                VStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Today is day \(calculateDayOfTreatment()) of treatment!").bold()
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .light ? .black : .black)
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .topLeading)
                    .background(colorScheme == .light ? Color.lightBlue : Color.darkTeal)
                    .cornerRadius(20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    SymptomChartRepresentable(symptomDataManager: symptomDataManager)
                    .frame(minHeight: 200)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    LastReactionInsight(symptomDataManager: symptomDataManager)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    SymptomChartRepresentable2(symptomDataManager: symptomDataManager)
                    .frame(minHeight: 200)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    DosesForMonthView(healthKitViewModel: healthKitViewModel)
                    .frame(minHeight: 230)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    VStack {
                        if !symptomDataManager.fetchAllSymptomsWithoutRefresh().isEmpty {
                            HStack {
                                Text("Symptoms").bold()
                                    .font(.title2)
                                    .foregroundColor(colorScheme == .light ? .black : .black)
                                    .padding()
                                Spacer()
                            }
                            PieChart(symptoms: symptomDataManager.fetchAllSymptomsWithoutRefresh(), slices: $slicesWithLabels)
                                .frame(height: 300)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                            Legend(slicesWithLabels: slicesWithLabels)
                                .padding()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    .background(colorScheme == .light ? Color.lightBlue : Color.darkTeal)
                    .cornerRadius(20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    .onAppear {
                        self.slicesWithLabels = calculateSlices(symptoms: symptomDataManager.fetchAllSymptomsWithoutRefresh())
                    }
                }
            }
        }
        .onAppear(perform: {
            healthKitViewModel.fetchDoseRecords()
        })
        .task {
            if #available(iOS 17.0, *) {
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
                Tips.showAllTipsForTesting()
            }
        }
    }

    private func calculateSlices(symptoms: [String]) -> [(Double, Color, String)] {
        let groupedSymptoms = Dictionary(grouping: symptoms, by: { $0 })
        var calculatedSlices: [(Double, Color, String)] = []

        for (_, (key, value)) in groupedSymptoms.enumerated() {
            let formattedKey = key.splitCamelCase()
            let slice = (Double(value.count) / Double(symptoms.count), Color.mutedRandom, formattedKey)
            calculatedSlices.append(slice)
        }

        return calculatedSlices
    }

    func calculateDayOfTreatment() -> Int {
        if let firstSymptomDate = symptomDataManager.symptomRecords.keys.sorted().first,
           let firstDoseDate = healthKitViewModel.doseRecords.keys.sorted().first {

            let firstDates = [firstSymptomDate, firstDoseDate]
            let minDate = firstDates.min()!

            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: minDate, to: Date())
            return (components.day ?? 0) + 1
        }

        if let firstSymptomDate = symptomDataManager.symptomRecords.keys.sorted().first {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstSymptomDate, to: Date())
            return (components.day ?? 0) + 1
        }

        if let firstDoseDate = healthKitViewModel.doseRecords.keys.sorted().first {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstDoseDate, to: Date())
            return (components.day ?? 0) + 1
        }

        return 1
    }
}
