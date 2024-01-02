//
//  InsightsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import Charts
import CareKitUI
import CareKit

struct InsightsView: View {
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    @ObservedObject var symptomDataManager = SymptomDataManager()
    var body: some View {
        VStack {
            HStack {
                Text("Insights")
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
            }
            ScrollView {
                SymptomComparisonView()
                    .environmentObject(healthKitViewModel)
            }
        }
    }
}
struct CareKitChartView: UIViewRepresentable {
    var dataSeries: [OCKDataSeries] // Use an array of OCKDataSeries for multiple series
    
    func makeUIView(context: Context) -> OCKCartesianChartView {
        let chartView = OCKCartesianChartView(type: .bar)
        return chartView
    }
    
    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        uiView.graphView.dataSeries = dataSeries // Assign the array of data series
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
        return symptoms.map { CGFloat($0.count) } // Convert symptom names to Double array
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd" // Customize date format as needed
        return dateFormatter.string(from: date)
    }
}

#Preview {
    InsightsView()
        .environmentObject(HealthKitViewModel())
}



//import SwiftUI
//import HealthKit
//import CareKitUI
//import Charts
//
//struct OCKCartesianChartWrapper: UIViewRepresentable {
//    var dataValues: [CGFloat]
//    var dataTitle: String
//
//    func makeUIView(context: Context) -> OCKCartesianChartView {
//        let chartView = OCKCartesianChartView(type: .bar)
//        chartView.headerView.titleLabel.text = dataTitle
//
//        let dataSeries = OCKDataSeries(values: dataValues, title: dataTitle)
//        chartView.graphView.dataSeries = [dataSeries]
//
//        return chartView
//    }
//
//    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
//        // Update view if needed
//    }
//}
//
//struct InsightsView: View {
//    var body: some View {
//        OCKCartesianChartWrapper(dataValues: [0, 1, 1, 2, 3, 3, 2], dataTitle: "Doxylamine")
//            .frame(width: 300, height: 200) // Set size if needed
//    }
//}
//
//#Preview {
//    InsightsView()
//}
//
//struct OCKDetailedContactWrapper: UIViewRepresentable {
//    func updateUIView(_ uiView: CareKitUI.OCKDetailedContactView, context: Context) {
//        //
//    }
//    
//    func makeUIView(context: Context) -> OCKDetailedContactView {
//        let contactView = OCKDetailedContactView()
//        return contactView
//    }
//}
//
//struct ContactInfoView: View {
//    var body: some View {
//        OCKDetailedContactWrapper()
//            .frame(width: 300, height: 400) // Set size if needed
//    }
//}
//
//#Preview {
//    ContactInfoView()
//}
//
//struct CareKitChartView: UIViewRepresentable {
//    var dataSeries: OCKDataSeries? // OCKDataSeries for symptom data
//
//    func makeUIView(context: Context) -> OCKCartesianChartView {
//        let chartView = OCKCartesianChartView(type: .line)
//        return chartView
//    }
//
//    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
//        if let dataSeries = dataSeries {
//            uiView.graphView.dataSeries = [dataSeries]
//        }
//    }
//}
//
//struct SymptomTrackerView: View {
//    let hkSymptoms: [String] = ["Symptom A", "Symptom B", "Symptom C"]
//
//    @State private var selectedSymptom: String = ""
//    @State private var symptomDataSeries: OCKDataSeries?
//
//    var body: some View {
//        VStack {
//            Picker("Select Symptom", selection: $selectedSymptom) {
//                ForEach(hkSymptoms, id: \.self) { symptom in
//                    Text(symptom).tag(symptom)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .padding()
//
//            if let dataSeries = symptomDataSeries {
//                CareKitChartView(dataSeries: dataSeries)
//                    .frame(height: 300)
//                    .padding()
//            } else {
//                Text("No data available for the selected symptom.")
//                    .foregroundColor(.gray)
//                    .padding()
//            }
//        }
//        .onChange(of: selectedSymptom) { newSymptom in
//            // Fetch data for the selected symptom from HealthKit or other data source
//            // Create an OCKDataSeries for the fetched data
//            // Update 'symptomDataSeries' with the created data series
//            fetchDataForSymptom(symptom: newSymptom)
//        }
//    }
//
//    func fetchDataForSymptom(symptom: String) {
//        // Fetch symptom data for the selected symptom
//        // Create an OCKDataSeries using the fetched data and assign it to 'symptomDataSeries'
//        // Example:
//        let dataPoints: [CGFloat] = [0, 1, 1, 2, 3, 3, 2] // Replace this with your symptom data
//        symptomDataSeries = OCKDataSeries(values: dataPoints, title: symptom)
//    }
//}
//
//#Preview {
//    SymptomTrackerView()
//}
