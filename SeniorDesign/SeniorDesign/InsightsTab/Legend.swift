//
//  Legend.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import SwiftUI

struct Legend: View {
    let slicesWithLabels: [(Double, Color, String)]

    var body: some View {
            VStack(alignment: .leading) {
                let columns = 2
                let rows = (slicesWithLabels.count + columns - 1) / columns

                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { column in
                            let index = row * columns + column
                            if index < slicesWithLabels.count {
                                let symptomName = slicesWithLabels[index].2
                                // \(symptomEmojis[slicesWithLabels[index].2] ?? "")
                                LegendItem(color: slicesWithLabels[index].1, label: "\(symptomName)")
                                    .frame(alignment: .leading)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top)
    }
}
