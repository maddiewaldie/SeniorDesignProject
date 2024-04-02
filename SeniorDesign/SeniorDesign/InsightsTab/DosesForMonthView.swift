//
//  DosesForMonthView.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import SwiftUI
import Charts

struct DosesForMonthView: View {
    @ObservedObject var healthKitViewModel: HealthKitViewModel
    @Environment(\.colorScheme) var colorScheme

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
                    .foregroundColor(colorScheme == .light ? .black : .black)
                    .padding()
                    .padding(.bottom, 0)
                Spacer()
            }
            Text("You took \(dosesTaken) doses and skipped \(dosesSkipped) doses this month.")
                .font(.subheadline)
                .foregroundColor(colorScheme == .light ? .gray : .darkGrey)
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
                    .foregroundStyle(colorScheme == .light ? Color.darkTeal : Color.darkerTeal)
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
