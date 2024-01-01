//
//  AboutYourDoseView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct AboutYourDoseView: View {
    let allergenDoses: DoseRecord

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("About Your Dose")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 5)
                    Spacer()
                }

                    VStack(alignment: .leading) {
                        ForEach(allergenDoses.doses.sorted(by: { $0.key < $1.key }), id: \.key) { (allergen, dose) in
                            HStack {
                                Text("\(allergen) • \(dose) mg")
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                                    .padding(.bottom, 5)
                                Spacer()
                            }
                        }
                    }
                    Spacer()

                    HStack {
                        Text(dateFormatter.string(from: allergenDoses.time))
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)
                        Spacer()
                    }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.lightTeal)
            .cornerRadius(20)
            .padding()

            HStack {
                Spacer()
                Image(systemName: "pills.fill")
                    .font(.system(size: 90))
                    .foregroundColor(Color.darkTeal)
                    .padding(.trailing, 35)
            }
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
