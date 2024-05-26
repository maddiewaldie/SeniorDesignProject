//
//  SymptomsThisWeekChartView.swift
//  OIT
//
//  Created by Maddie on 4/3/24.
//

import Foundation
import SwiftUI
import CareKitUI
import CareKit

struct SymptomsThisWeekChartView: UIViewRepresentable {
    let symptomDataManager: SymptomDataManager

    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .bar)
        chartView.headerView.titleLabel.text = "Symptoms This Week"

        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let symptomRecordsPastWeek = symptomDataManager.symptomRecords.filter { $0.key >= oneWeekAgo }
        let symptomRecordsByDate = symptomRecordsPastWeek.sorted(by: { $0.key < $1.key })
        var allSymptoms: Set<String> = []
        for (_, symptoms) in symptomRecordsByDate {
            allSymptoms.formUnion(symptoms)
        }

        for (index, symptom) in allSymptoms.enumerated() {
            let counts = symptomRecordsByDate.map { (_, symptoms) in
                symptoms.contains(symptom) ? 1.0 : 0.0
            }
            let dataSeries = OCKDataSeries(values: counts.map { CGFloat($0) }, title: symptom.splitCamelCase(), color: UIColor(Color.mutedRandom))
            chartView.graphView.dataSeries.append(dataSeries)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        chartView.graphView.horizontalAxisMarkers = symptomRecordsByDate.map { dateFormatter.string(from: $0.key) }
        chartView.graphView.yMaximum = 1
        chartView.graphView.yMinimum = 0

        return chartView
    }

    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        // Update the view if needed
    }
}
