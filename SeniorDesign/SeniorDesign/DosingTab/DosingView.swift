//
//  DosingView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import TipKit

struct DosingViewTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Add your OIT dosages here!")
    }

    var message: Text? {
        Text("Begin by tapping the + button to effortlessly add your doses. Once doses are added, simply swipe to access options for editing, deleting, or designating them as your current dose.")
    }

    var image: Image? {
        Image(systemName: "lightbulb.max.fill")
    }
}

struct DosingView: View {
    // MARK: View Models
    @EnvironmentObject var doseViewModel: DoseViewModel

    // MARK: Variables
    @State private var createNewDose = false
    @State private var isEditing = false
    @Environment(\.colorScheme) var colorScheme

    @State private var showFilterOptions = false
    @State private var selectedFilter: FilterOption = .all

    var dosingTip = DosingViewTip()

    enum FilterOption: String, CaseIterable {
        case all = "All Doses"
        case currentDoses = "Show Only Current Doses"
    }

    var filterButton: some View {
        Menu {
            ForEach(FilterOption.allCases, id: \.self) { option in
                Button(action: {
                    selectedFilter = option
                }) {
                    Label(option.rawValue, systemImage: selectedFilter == option ? "checkmark" : "")
                }
            }
        } label: {
            Image(systemName: "line.horizontal.3.decrease.circle")
        }
        .padding()
    }

    var filteredDoses: [AllergenWithDoses] {
        var filteredAllergens = doseViewModel.allergensWithDoses

        switch selectedFilter {
        case .all:
            break
        case .currentDoses:
            filteredAllergens = filteredAllergens.map { allergenWithDoses in
                AllergenWithDoses(
                    allergen: allergenWithDoses.allergen,
                    doses: allergenWithDoses.doses.filter(\.isCurrentDose)
                )
            }
        }

        return filteredAllergens
    }
    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    // MARK: UI Elements
    var createNewDoseButton: some View {
        Button(action: {
            createNewDose = true
        }, label: {
            Image(systemName: "plus")
                .foregroundColor(Color.darkTeal)
        })
        .sheet(isPresented: $createNewDose, content: {
            AddDoseView(isEditing: $isEditing)
                .environmentObject(doseViewModel)
        })
        .padding()
    }

    var header: some View {
        HStack {
            Text("Doses")
                .font(.largeTitle.bold())
                .padding()
            Spacer()
            filterButton
            createNewDoseButton
        }
    }

    @State private var expandedStates: [String: Bool] = [:]

    var listOfDoses: some View {
        List {
            if filteredDoses.isEmpty {
                Text("Click the + button to add a dose.")
                    .foregroundColor(.gray)
                    .padding()
            }
            ForEach(filteredDoses) { allergenWithDoses in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedStates[allergenWithDoses.allergen] ?? false },
                                set: { expandedStates[allergenWithDoses.allergen] = $0 }
                            ),
                    content: {
                        ForEach(allergenWithDoses.doses) { dose in
                            DoseRowView(dose: dose, numberFormatter: numberFormatter, viewModel: doseViewModel, isEditing: $isEditing)
                        }
                        .onDelete { indices in
                            indices.forEach { index in
                                doseViewModel.deleteDose(allergenWithDoses.doses[index])
                            }
                        }
                    },
                    label: {
                        Text(allergenWithDoses.allergen)
                            .font(.title2)
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                )
            }
        }
        .listStyle(PlainListStyle())
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onAppear {
            doseViewModel.loadDoses()
            for allergenWithDoses in doseViewModel.allergensWithDoses {
                expandedStates[allergenWithDoses.allergen] = true
            }
        }
    }

    // MARK: Dosing View
    var body: some View {
        VStack(alignment: .leading) {
            header
            if #available(iOS 17.0, *) {
                TipView(dosingTip, arrowEdge: .none)
                    .tipCornerRadius(15)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
            }
            listOfDoses
        }
        .task {
            if #available(iOS 17.0, *) {
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
                Tips.showAllTipsForTesting()
            }
        }
    }
}

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
                        .foregroundColor(Color.darkTeal)
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
           .tint(Color.darkTeal)

            Button {
                isEditing.wrappedValue = true
                createNewDose = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .sheet(isPresented: $createNewDose, content: {
                AddDoseView(isEditing: $isEditing.wrappedValue)
                    .environmentObject(viewModel)
            })
            .tint(Color.yellow)
       }
    }
}

// MARK: Dose View Model Extension
extension DoseViewModel {
    var allergensWithDoses: [AllergenWithDoses] {
        let groupedDoses = Dictionary(grouping: doses, by: { $0.allergen })
        let sortedAllergens = groupedDoses.keys.sorted()
        return sortedAllergens.map { allergen in
            AllergenWithDoses(allergen: allergen, doses: groupedDoses[allergen]!)
        }
    }
}

// MARK: Allergen with Doses
struct AllergenWithDoses: Identifiable, Hashable {
    static func == (lhs: AllergenWithDoses, rhs: AllergenWithDoses) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    let id = UUID()
    let allergen: String
    let doses: [Dose]
}

// MARK: Preview
#Preview {
    DosingView()
        .environmentObject(DoseViewModel())
}
