//
//  LastReactionInsight.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import SwiftUI

struct LastReactionInsight: View {
    @ObservedObject var symptomDataManager: SymptomDataManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if let lastReactionDate = symptomDataManager.lastReactionDate() {
                let daysSinceLastReaction = Calendar.current.dateComponents([.day], from: lastReactionDate, to: Date()).day ?? 0

                HStack(alignment: .center) {
                    Spacer()
                    if daysSinceLastReaction <= 2 {
                        Text("Don't worry, it's okay. Things will improve. It's been \(daysSinceLastReaction) days since your last reaction.").bold()
                            .foregroundColor(colorScheme == .light ? .black : .black)
                    } else {
                        Text("Congratulations! It's been \(daysSinceLastReaction) days since your last reaction!").bold()
                            .foregroundColor(colorScheme == .light ? .black : .black)
                    }
                    Spacer()
                }
                .font(.subheadline)
                .padding()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(colorScheme == .light ? Color.lightBlue : Color.darkTeal)
        .cornerRadius(20)
    }
}
