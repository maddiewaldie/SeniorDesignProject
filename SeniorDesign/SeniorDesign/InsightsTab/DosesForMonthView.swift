//
//  DosesForMonthView.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//
import SwiftUI
import CareKitUI

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
            ChartViewRepresentable(allDates: allDates, healthKitViewModel: healthKitViewModel, colorScheme: colorScheme)
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

struct ChartViewRepresentable: UIViewRepresentable {
    let allDates: [Date]
    let healthKitViewModel: HealthKitViewModel
    let colorScheme: ColorScheme

    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .line)

        // Set the title
        chartView.headerView.titleLabel.text = "Doses This Month"

        // Set the data series
        var dataSeries = OCKDataSeries(values: allDates.map { date in
            let doseCount = Double(healthKitViewModel.doseRecords.values.filter { record in
                if let doseDate = (record as? DoseRecord)?.date {
                    let components = Calendar.current.dateComponents([.day, .month, .year], from: doseDate)
                    return components == Calendar.current.dateComponents([.day, .month, .year], from: date)
                }
                return false
            }.count)
            // Ensure to return a CGFloat
            return CGFloat(doseCount)
        }, title: "Dose Taken", color: UIColor(Color.lightTeal))
        dataSeries.size = 3

        let (dosesTaken, dosesSkipped) = countDoses()
        chartView.headerView.detailLabel.text = "You took \(dosesTaken) doses and skipped \(dosesSkipped) doses this month."
        chartView.graphView.dataSeries = [dataSeries]
        chartView.graphView.yMaximum = 1
        chartView.graphView.yMinimum = 0
        return chartView
    }

    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        // Update the view if needed
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

struct DosesForMonthView_Previews: PreviewProvider {
    static var previews: some View {
        DosesForMonthView(healthKitViewModel: HealthKitViewModel())
    }
}
