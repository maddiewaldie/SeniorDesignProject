//
//  CalendarDayView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct CalendarDayView: View {
    // MARK: Variables
    @Binding var selectedDate: Date
    @Binding var selectedColorIndex: Int?
    @Environment(\.colorScheme) var colorScheme
    var date: Date
    var index: Int

    private var isSelected: Bool {
        selectedDate == date
    }

    private var isSelectable: Bool {
        return date <= Date()
    }

    private var dayText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return String(dateFormatter.string(from: date).prefix(1))
    }

    private var dateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }

    private var circleColor: Color {
        if !isSelectable {
            return colorScheme == .light ? Color.lightGrey : Color.darkGrey
        }
        if isSelected {
            return colorScheme == .light ? .darkTeal : .darkerTeal // Color for selected circle
        } else if let selectedColorIndex = selectedColorIndex, selectedColorIndex == index {
            return colorScheme == .light ? .lightTeal : .darkTeal // Color for previously tapped circle
        } else {
            return colorScheme == .light ? .lightTeal : .darkTeal // Default color for other circles
        }
    }

    private var circleTextColor: Color {
        if !isSelectable {
            return colorScheme == .light ? Color.mediumGrey : Color.black
        }
        if isSelected {
            return colorScheme == .light ? Color.white : Color.black
        } else if let selectedColorIndex = selectedColorIndex, selectedColorIndex == index {
            return Color.black
        } else {
            return Color.black        }
    }

    // MARK: UI Elements
    private var dayOfWeek: some View {
        Text(dayText)
            .font(.caption)
            .bold()
    }

    private var dayCircle: some View {
        Circle()
            .frame(width: min(UIScreen.main.bounds.width / 10, 70), height: min(UIScreen.main.bounds.width / 7, 70))
            .overlay(
                Text(dateText)
                    .font(.subheadline)
                    .foregroundColor(circleTextColor)
                    .bold()
            )
            .onTapGesture {
                if isSelectable {
                    selectedDate = date
                    selectedColorIndex = index
                }
            }
            .foregroundColor(circleColor)
            .cornerRadius(8)
            .disabled(!isSelectable)
    }


    // MARK: Calendar Day View
    var body: some View {
        VStack {
            dayOfWeek
            dayCircle
        }
    }
}
