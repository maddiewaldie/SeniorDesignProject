//
//  SymptomsOverTimeChartView.swift
//  OIT
//
//  Created by Maddie on 4/3/24.
//

import Foundation
import SwiftUI
import CareKitUI
import CareKit

struct SymptomsOverTimeChartView: UIViewRepresentable {
    let symptomDataManager: SymptomDataManager
    @Environment(\.colorScheme) var colorScheme

    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .bar)
        chartView.headerView.titleLabel.text = "Symptoms Over Time"

        _ = symptomDataManager.fetchAllSymptoms()
        let symptomRecordsByDate = symptomDataManager.symptomRecords
        var dataPoints: [(Date, Int)] = []
        for (date, symptoms) in symptomRecordsByDate {
            dataPoints.append((date, symptoms.count))
        }
        dataPoints.sort { $0.0 < $1.0 }
        _ = dataPoints.map { $0.0 }
        let counts = dataPoints.map { Double($0.1) }

        let dataSeries = OCKDataSeries(values: counts.map { CGFloat($0) }, title: "Symptoms", color: colorScheme == .light ? UIColor(.darkTeal) : UIColor(.lightTeal))
        chartView.graphView.dataSeries = [dataSeries]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return chartView
    }

    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        // Update the view if needed
    }
}
