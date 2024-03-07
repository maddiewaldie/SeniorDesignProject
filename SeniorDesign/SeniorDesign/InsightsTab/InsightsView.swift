//
//  InsightsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import CoreData
import Charts
import TipKit

struct InsightsTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Unlock Your Health Insights")
    }

    var message: Text? {
        Text("Discover personalized stats and insightful graphs based on your symptoms and doses. Track your progress, gain valuable health insights, and make informed decisions on your journey to wellness.")
    }

    var image: Image? {
        Image(systemName: "waveform.badge.magnifyingglass")
    }
}

struct InsightsView: View {
    // MARK: View Model
    @ObservedObject var healthKitViewModel: HealthKitViewModel
    @ObservedObject var symptomDataManager = SymptomDataManager()
    @State private var slicesWithLabels: [(Double, Color, String)] = []

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
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color.init(hex: "e9f5f9"))
                    .cornerRadius(20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    LastReactionInsight(symptomDataManager: symptomDataManager)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    VStack {
                        if symptomDataManager.fetchAllSymptoms().isEmpty {
                            Text("No data available for symptoms.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            HStack {
                                Text("Symptoms").bold()
                                    .font(.title2)
                                    .padding()
                                Spacer()
                            }
                            Pie(symptoms: symptomDataManager.fetchAllSymptoms(), slices: $slicesWithLabels)
                                .frame(height: 300)
                                .padding()
                            Legend(slicesWithLabels: slicesWithLabels)
                                .padding()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color.init(hex: "e9f5f9"))
                    .cornerRadius(20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .onAppear {
                        self.slicesWithLabels = calculateSlices(symptoms: symptomDataManager.fetchAllSymptoms())
                    }
                    VStack {
                        DosesForMonth(healthKitViewModel: healthKitViewModel)
                        .padding(.bottom, 20)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color.init(hex: "e9f5f9"))
                    .cornerRadius(20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 20)
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
            let formattedKey = splitCamelCase(key)
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
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        if let firstSymptomDate = symptomDataManager.symptomRecords.keys.sorted().first {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstSymptomDate, to: Date())
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        if let firstDoseDate = healthKitViewModel.doseRecords.keys.sorted().first {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: firstDoseDate, to: Date())
            return (components.day ?? 0) + 1 // Adding 1 to start from Day 1
        }

        return 1
    }
}

struct DosesForMonth: View {
    @ObservedObject var healthKitViewModel: HealthKitViewModel

    private var allDates: [Date] {
        let calendar = Calendar.current
        let currentDate = Date()

        guard let startDate = calendar.date(byAdding: .month, value: -1, to: currentDate) else {
            fatalError("Error calculating start date of the past month")
        }

        var dates: [Date] = []
        var currentDateIter = startDate
        while currentDateIter <= currentDate {
            dates.append(currentDateIter)
            currentDateIter = calendar.date(byAdding: .day, value: 1, to: currentDateIter)!
        }

        return dates
    }

    var body: some View {
        let (dosesTaken, dosesSkipped) = countDoses()
        return VStack {
            HStack {
                Text("Doses This Month").bold()
                    .font(.title2)
                    .padding()
                    .padding(.bottom, 0)
                Spacer()
            }
            Text("You took \(dosesTaken) doses and skipped \(dosesSkipped) doses this month.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            Chart {
                ForEach(allDates, id: \.self) { date in
                    let doseCount = healthKitViewModel.doseRecords.values
                        .filter { record in
                            guard let doseDate = (record as? DoseRecord)?.date else { return false }
                            let components = Calendar.current.dateComponents([.day, .month, .year], from: doseDate)
                            return components == Calendar.current.dateComponents([.day, .month, .year], from: date)
                        }
                        .count

                    LineMark(
                        x: .value("Date", date),
                        y: .value("Allergens", Double(doseCount))
                    )
                    .foregroundStyle(Color.darkTeal)
                }
            }
            .frame(height: 200)
            .padding()
            .chartYAxis {}
        }
    }

    private func countDoses() -> (Int, Int) {
            var dosesTaken = 0
            var dosesSkipped = 0

            for date in allDates {
                if healthKitViewModel.doseRecords.values.contains(where: { record in
                    if let doseDate = (record as? DoseRecord)?.date {
                        let components = Calendar.current.dateComponents([.day, .month, .year], from: doseDate)
                        return components == Calendar.current.dateComponents([.day, .month, .year], from: date)
                    }
                    return false
                }) {
                    dosesTaken += 1
                } else {
                    dosesSkipped += 1
                }
            }

            return (dosesTaken, dosesSkipped)
        }
}

struct LastReactionInsight: View {
    @ObservedObject var symptomDataManager: SymptomDataManager

    var body: some View {
        VStack {
            if let lastReactionDate = symptomDataManager.lastReactionDate() {
                let daysSinceLastReaction = Calendar.current.dateComponents([.day], from: lastReactionDate, to: Date()).day ?? 0

                HStack(alignment: .center) {
                    Spacer()
                    if daysSinceLastReaction <= 2 {
                        Text("Don't worry, it's okay. Things will improve. It's been \(daysSinceLastReaction) days since your last reaction.").bold()
                    } else {
                        Text("Congratulations! It's been \(daysSinceLastReaction) days since your last reaction!").bold()
                    }
                    Spacer()
                }
                .font(.subheadline)
                .padding()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.init(hex: "e9f5f9"))
        .cornerRadius(20)
    }
}

private func splitCamelCase(_ input: String) -> String {
    var formattedString = input.replacingOccurrences(of: "HKCategoryTypeIdentifier", with: "")

    let pattern = "(\\w)([A-Z])"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: formattedString.utf16.count)

    let matches = regex.matches(in: formattedString, options: [], range: range)
    for match in matches.reversed() {
        let index = formattedString.index(formattedString.startIndex, offsetBy: match.range(at: 2).location)
        if index < formattedString.endIndex {
            formattedString.insert(" ", at: index)
        }
    }

    return formattedString
}


struct Legend: View {
    let slicesWithLabels: [(Double, Color, String)]

    var body: some View {
            VStack(alignment: .leading) {
                let columns = 2
                let rows = (slicesWithLabels.count + columns - 1) / columns

                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { column in
                            let index = row * columns + column
                            if index < slicesWithLabels.count {
                                let symptomName = slicesWithLabels[index].2
                                // \(symptomEmojis[slicesWithLabels[index].2] ?? "")
                                LegendItem(color: slicesWithLabels[index].1, label: "\(symptomName)")
                                    .frame(alignment: .leading)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top)
    }
}

struct Pie: View {
    let symptoms: [String]
    @Binding var slices: [(Double, Color, String)]

    var body: some View {
        Canvas { context, size in
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            let gapSize = Angle(degrees: 5) // size of the gap between slices in degrees

            var startAngle = Angle.zero
            for (value, color, name) in slices {
                let angle = Angle(degrees: 360 * value)
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle + Angle(degrees: 5) / 2, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
        }
        .padding(.horizontal)
    }
}
