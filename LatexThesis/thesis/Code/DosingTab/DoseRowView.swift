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

    @State private var createNewDose = false
    @State private var editingDose: Dose?

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
                editingDose = dose
            }, label: {
                Label("Edit", systemImage: "pencil")
            })
            .tint(.yellow)
       }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: AddDoseView(editingDose: editingDose)
                    .environmentObject(viewModel),
                isActive: Binding<Bool>(
                    get: { editingDose != nil },
                    set: { _ in editingDose = nil }
                ),
                label: { EmptyView() }
            )
            .hidden()
        )
    }
}
