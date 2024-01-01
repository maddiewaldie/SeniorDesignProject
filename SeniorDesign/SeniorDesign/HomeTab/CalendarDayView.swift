//
//  CalendarDayView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI
struct CalendarDayView: View {
    var date: Date
    @Binding var selectedDate: Date
    @Binding var selectedColorIndex: Int?

    var index: Int
    var isSelected: Bool {
        selectedDate == date
    }

    var body: some View {
        VStack {
            Text(dayText)
                .font(.caption)
                .bold()
            Circle()
                .frame(width: min(UIScreen.main.bounds.width / 10, 70), height: min(UIScreen.main.bounds.width / 7, 70))
                .overlay(
                    Text(dateText)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .bold()
                )
                .onTapGesture {
                    selectedDate = date
                    selectedColorIndex = index // Set the index of the tapped circle
                }
                .foregroundColor(circleColor)
                .cornerRadius(8)
        }
    }

    var dayText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return String(dateFormatter.string(from: date).prefix(1))
    }

    var dateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }

    var circleColor: Color {
        if isSelected {
            return Color.darkTeal // Color for selected circle
        } else if let selectedColorIndex = selectedColorIndex, selectedColorIndex == index {
            return Color.lightTeal // Color for previously tapped circle
        } else {
            return Color.lightTeal // Default color for other circles
        }
    }
}
