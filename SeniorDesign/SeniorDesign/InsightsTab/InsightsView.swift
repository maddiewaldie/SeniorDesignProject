//
//  InsightsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import CareKit
import CareKitUI
import Charts
import SwiftUI

struct InsightsView: View {
    // MARK: View Model
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @ObservedObject var symptomDataManager = SymptomDataManager()

    var header: some View {
        HStack {
            Text("Insights")
                .font(.largeTitle.bold())
                .padding()
            Spacer()
        }
    }

    // MARK: Insights View
    var body: some View {
        VStack {
            header
            ScrollView {
                SymptomComparisonView()
                    .environmentObject(healthKitViewModel)
            }
        }
    }
}

struct CareKitChartView: UIViewRepresentable {
    var dataSeries: [OCKDataSeries]
    
    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .bar)
        return chartView
    }
    
    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        uiView.graphView.dataSeries = dataSeries
    }
}

struct SymptomComparisonView: View {
    @ObservedObject var symptomDataManager = SymptomDataManager()
    
    var body: some View {
        VStack {
            if symptomDataManager.symptomRecords.isEmpty {
                Text("No data available for symptoms.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                CareKitChartView(dataSeries: fetchSymptomData())
                    .frame(height: UIScreen.main.bounds.height * 0.5)
            }
        }
    }
    
    func fetchSymptomData() -> [OCKDataSeries] {
        var dataSeriesArray: [OCKDataSeries] = []
        
        for (date, symptoms) in symptomDataManager.symptomRecords {
            let dataPoints = convertSymptomDataToCGFloat(symptoms)
            let dataSeries = OCKDataSeries(values: dataPoints, title: formatDate(date))
            dataSeriesArray.append(dataSeries)
        }
        
        return dataSeriesArray
    }
    
    func convertSymptomDataToCGFloat(_ symptoms: [String]) -> [CGFloat] {
        return symptoms.map { CGFloat($0.count) }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: Preview
#Preview {
    InsightsView()
        .environmentObject(HealthKitViewModel())
}
