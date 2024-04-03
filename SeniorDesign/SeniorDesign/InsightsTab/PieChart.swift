//
//  PieChart.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import SwiftUI
import CareKitUI
import CareKit

struct PieChart: View {
    let symptoms: [String]
    @Binding var slices: [(Double, Color, String)]

    var body: some View {
        Canvas { context, size in
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48

            var startAngle = Angle.zero
            for (value, color, _) in slices {
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

struct SymptomChartRepresentable: UIViewRepresentable {
    let symptomDataManager: SymptomDataManager

    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .bar)

        // Set the title
        chartView.headerView.titleLabel.text = "Symptoms Over Time"

        // Fetch all symptom records
        _ = symptomDataManager.fetchAllSymptoms()

        // Group symptoms by date
        let symptomRecordsByDate = symptomDataManager.symptomRecords

        // Create an array of tuples containing date and symptom count
        var dataPoints: [(Date, Int)] = []
        for (date, symptoms) in symptomRecordsByDate {
            dataPoints.append((date, symptoms.count))
        }

        // Sort the data points by date
        dataPoints.sort { $0.0 < $1.0 }

        // Extract dates and counts
        _ = dataPoints.map { $0.0 }
        let counts = dataPoints.map { Double($0.1) }

        // Create data series
        let dataSeries = OCKDataSeries(values: counts.map { CGFloat($0) }, title: "Symptoms", color: UIColor(.lightTeal))
        chartView.graphView.dataSeries = [dataSeries]

        // Set x-axis labels to dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
//        chartView.graphView.horizontalAxisMarkers = dates.map { dateFormatter.string(from: $0) }

        return chartView
    }

    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        // Update the view if needed
    }
}

struct SymptomChartRepresentable2: UIViewRepresentable {
    let symptomDataManager: SymptomDataManager

    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .bar)

        // Set the title
        chartView.headerView.titleLabel.text = "Symptoms This Week"

        // Fetch symptom records for the past week
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let symptomRecordsPastWeek = symptomDataManager.symptomRecords.filter { $0.key >= oneWeekAgo }

        // Group symptoms by date
        let symptomRecordsByDate = symptomRecordsPastWeek.sorted(by: { $0.key < $1.key })

        // Extract all unique symptoms
        var allSymptoms: Set<String> = []
        for (_, symptoms) in symptomRecordsByDate {
            allSymptoms.formUnion(symptoms)
        }

        // Assign a different color to each data series
        let colors: [UIColor] = [.red, .green, .blue, .orange, .purple, .yellow, .cyan, .magenta, .brown, .systemPink]

        // Create data series for each symptom
        for (index, symptom) in allSymptoms.enumerated() {
            let counts = symptomRecordsByDate.map { (_, symptoms) in
                symptoms.contains(symptom) ? 1.0 : 0.0
            }
            let color = colors[index % colors.count]
            let dataSeries = OCKDataSeries(values: counts.map { CGFloat($0) }, title: symptom.splitCamelCase(), color: color)
            chartView.graphView.dataSeries.append(dataSeries)
        }

        // Set x-axis labels to dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // Abbreviated day of the week
        chartView.graphView.horizontalAxisMarkers = symptomRecordsByDate.map { dateFormatter.string(from: $0.key) }

        chartView.graphView.yMaximum = 1
        chartView.graphView.yMinimum = 0

        return chartView
    }

    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        // Update the view if needed
    }
}
