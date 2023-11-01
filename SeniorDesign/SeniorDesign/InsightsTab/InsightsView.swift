//
//  InsightsView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import Charts

struct MonthlyHoursOfSunshine: Identifiable {
    var id = UUID()
    var date: Date
    var hoursOfSunshine: Double


    init(month: Int, hoursOfSunshine: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: 2020, month: month))!
        self.hoursOfSunshine = hoursOfSunshine
    }
}


var data: [MonthlyHoursOfSunshine] = [
    MonthlyHoursOfSunshine(month: 1, hoursOfSunshine: 10),
    MonthlyHoursOfSunshine(month: 2, hoursOfSunshine: 30),
    MonthlyHoursOfSunshine(month: 3, hoursOfSunshine: 20),
    MonthlyHoursOfSunshine(month: 4, hoursOfSunshine: 15),
    MonthlyHoursOfSunshine(month: 5, hoursOfSunshine: 45),
    MonthlyHoursOfSunshine(month: 6, hoursOfSunshine: 99),
    MonthlyHoursOfSunshine(month: 7, hoursOfSunshine: 62)
]

struct InsightsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Insights")
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
            }
            ScrollView {
                VStack {
                    Chart(data) {
                        LineMark(
                            x: .value("Month", $0.date),
                            y: .value("Hours of Sunshine", $0.hoursOfSunshine)
                        )
                    }
                    .foregroundColor(Color.darkTeal)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 170)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .padding()
                    .padding(.top, 30)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .background(Color.lightTeal)
                .cornerRadius(30)
                
                VStack {
                    Chart(data) {
                        BarMark(
                            x: .value("Month", $0.date),
                            y: .value("Hours of Sunshine", $0.hoursOfSunshine)
                        )
                    }
                    .foregroundColor(Color.darkTeal)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 170)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .padding()
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .background(Color.lightTeal)
                .cornerRadius(30)
                Spacer()
                
                VStack {
                    Chart(data) {
                        LineMark(
                            x: .value("Month", $0.date),
                            y: .value("Hours of Sunshine", $0.hoursOfSunshine)
                        )
                    }
                    .foregroundColor(Color.darkTeal)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 170)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .padding()
                    .padding(.top, 30)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .background(Color.lightTeal)
                .cornerRadius(30)
                
                VStack {
                    Chart(data) {
                        BarMark(
                            x: .value("Month", $0.date),
                            y: .value("Hours of Sunshine", $0.hoursOfSunshine)
                        )
                    }
                    .foregroundColor(Color.darkTeal)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 170)
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .padding()
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .background(Color.lightTeal)
                .cornerRadius(30)
                Spacer()
            }
        }
    }
}

#Preview {
    InsightsView()
}
