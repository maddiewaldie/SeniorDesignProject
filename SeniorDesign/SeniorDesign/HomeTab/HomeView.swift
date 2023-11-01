//
//  HomeView.swift
//  SeniorDesign
//
//  Created by Maddie on 8/20/23.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var weekView = true
    @State private var logSymptoms = false
    @State private var logDose = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: SettingsView().environmentObject(HealthKitViewModel())) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 16)
                    Spacer()

                    HStack {
                        Text(monthHeader)
                            .font(.body)
                            .bold()
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 20)
                    }
                    .onTapGesture {
                        weekView.toggle()
                    }
                }
                    VStack {
                        if weekView {
                            WeeklyScrollCalendarView
                                .padding(.bottom, -10)
                        }
                        ScrollView {
                            if weekView {
                            Circle()
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .padding(.bottom, 10)
                                .foregroundColor(Color.lightTeal)
                                .overlay(
                                    VStack {
                                        Text("Day")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .bold()
                                            .padding(.top, 30)
                                        Text("365")
                                            .font(.system(size: 70))
                                            .foregroundColor(.black)
                                            .bold()
                                        Text("of Treatment")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .bold()
                                        Button(action: {
                                            logDose.toggle()
                                        }) {
                                            Text("Log Dose         ")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                                .padding()
                                                .background(Color.darkTeal)
                                                .cornerRadius(30)
                                        }
                                        .sheet(isPresented: $logDose) {
                                            DosingPopUp()
                                        }
                                        .padding()
                                    }
                                )
                        } else {
                            DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .tint(Color.lightTeal)
                        }
                        AboutYourDoseView()
                        HStack {
                            Button(action: {
                                logSymptoms.toggle()
                            }) {
                                VStack {
                                    Text("Log your Symptoms")
                                        .foregroundColor(.black)
                                        .padding(.bottom, 20)
                                    Image(systemName: "plus")
                                        .foregroundColor(.black)
                                }
                                .frame(width: 130, height: 150)
                                .background(Color.lightTeal)
                                .cornerRadius(20)
                            }
                            .sheet(isPresented: $logSymptoms) {
                                SymptomsPopUp()
                            }
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        
                    }
                }
            }
        }
    }

    var WeeklyScrollCalendarView: some View {
        VStack {
            VStack {
                HStack(alignment: .center, spacing: 14) {
                    ForEach(0..<7, id: \.self) { index in
                        let day = Calendar.current.date(byAdding: .day, value: index, to: startOfWeek)!

                        CalendarDayView(date: day, isSelected: day == selectedDate)
                    }
                }
            }
            .padding()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { value in
                let weekInterval: TimeInterval = 60 * 60 * 24 * 7
                if value.translation.width > 50 {
                    selectedDate = selectedDate.addingTimeInterval(-weekInterval)
                } else if value.translation.width < -50 {
                    selectedDate = selectedDate.addingTimeInterval(weekInterval)
                }
            }
        )
    }

    private var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
        var startComponents = DateComponents()
        startComponents.yearForWeekOfYear = components.yearForWeekOfYear
        startComponents.weekOfYear = components.weekOfYear
        startComponents.weekday = 1 // Sunday
        return calendar.date(from: startComponents)!
    }

    private var monthHeader: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: startOfWeek)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
