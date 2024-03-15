//
//  DoseRowView.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import SwiftUI

struct DoseRowView: View {
    let dose: Dose
    let numberFormatter: NumberFormatter
    let viewModel: DoseViewModel

    @State var isEditing: Binding<Bool>
    @State private var createNewDose = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dose.doseType)
                    .font(.headline)
                if dose.isCurrentDose {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.darkTeal)
                }
            }
            if let formattedDosage = numberFormatter.string(for: dose.doseAmount) {
                Text("Dosage: \(formattedDosage) mg")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .swipeActions(edge: .leading) {
           Button {
               viewModel.setAsCurrentDose(dose)
           } label: {
               Label("Set as Current", systemImage: "star")
           }
           .tint(.darkTeal)

            Button(action: {
                isEditing.wrappedValue = false
                self.createNewDose = true
            }, label: {
                Label("Edit", systemImage: "pencil")
            })
            .sheet(isPresented: $createNewDose, content: {
                AddDoseView(isEditing: $isEditing.wrappedValue)
                    .environmentObject(viewModel)
            })
            .tint(Color.lightYellow)
       }
    }
}
