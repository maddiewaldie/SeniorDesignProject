//
//  AboutYourDoseView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/20/23.
//

import SwiftUI

struct AboutYourDoseView: View {
    // MARK: Variables
    let allergenDoses: DoseRecord

    // MARK: UI Elements
    private var header: some View {
        HStack {
            Text("About Your Dose")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.bottom, 5)
            Spacer()
        }
    }

    private var dosesTaken: some View {
        VStack(alignment: .leading) {
            if let data = allergenDoses.doses as? Data,
               let doses = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String] {
                ForEach(doses.sorted(by: { $0.key < $1.key }), id: \.key) { (allergen, dose) in
                    let formattedDose = dose.components(separatedBy: "•").last?
                        .replacingOccurrences(of: ".0", with: "") ?? ""
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    HStack {
                        Text("\(allergen) • \(formattedDose)")
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                }
            }
        }
    }

    private var timeOfDose: some View {
        HStack {
            Text(timeFormatter.string(from: allergenDoses.time!))
                .foregroundColor(.black)
                .padding(.leading, 20)
                .padding(.bottom, 10)
            Spacer()
        }
    }

    // MARK: About Your Dose View
    var body: some View {
        ZStack {
            VStack {
                header
                HStack {
                    dosesTaken
                        .frame(width: 230)
                    Spacer()
                }
                Spacer()
                timeOfDose
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.lightTeal)
            .cornerRadius(20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            HStack {
                Spacer()
                Image(systemName: "pills.fill")
                    .font(.system(size: 90))
                    .foregroundColor(Color.darkTeal)
                    .padding(.trailing, 35)
            }
        }
    }

    // MARK: Functions
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
