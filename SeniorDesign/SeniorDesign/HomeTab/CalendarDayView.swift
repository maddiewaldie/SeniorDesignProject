//
//  CalendarDayView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct CalendarDayView: View {
    var date: Date
    var isSelected: Bool

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
                    //                    selectedDate = day
                }
                .foregroundColor(isSelected ? Color.darkTeal : Color.lightTeal)
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
}
