//
//  LegendItem.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import SwiftUI

struct LegendItem: View {
    let color: Color
    let label: String

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(label)
                .font(.system(size: 14)).bold()
                .foregroundColor(colorScheme == .light ? .black : .black)
        }
        .padding(.horizontal)
    }
}
