//
//  DosingView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI

struct DosingView: View {
    @State private var createNewDose = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Doses")
                    .font(.largeTitle.bold())
                    .padding()
                Spacer()
                Image(systemName: "plus")
                    .padding()
                    .onTapGesture {
                        createNewDose = true
                    }
                    .sheet(isPresented: $createNewDose, content: {
                        AddDoseView()
                    })
            }
            Spacer()
        }
    }
}

#Preview {
    DosingView()
}
