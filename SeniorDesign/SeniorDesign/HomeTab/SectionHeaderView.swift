//
//  SectionHeaderView.swift
//  SeniorDesign
//
//  Created by Maddie on 1/1/24.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
