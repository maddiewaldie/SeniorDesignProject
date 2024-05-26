//
//  EducationView.swift
//  SeniorDesign
//
//  Created by Maddie on 10/18/23.
//

import SwiftUI
import TipKit

struct ImageData: Codable {
    var imageData: Data
}

struct EducationView: View {
    // MARK: Variables
    let content = EducationViewContent()
    var resourcesTip = ResourcesTip()
    var esTip = EmergencyServicesTip()
    var infoTip = ImportantDocumentsTip()
    var doctorTip = DoctorPhoneTip()

    @State var doctorPhoneNumber: String = ""
    @State var isShowingImagePicker: Bool = false
    @State private var selectedImages: [UIImage] = []
    @State private var storedImageData: [ImageData] = []

    @Environment(\.colorScheme) var colorScheme

    // MARK: UI Elements
    var articles: some View {
        VStack(alignment: .leading) {
            ArticleRichLink(articleTitle: "Anaphylaxis", articleDescription: "Learn the signs & symptoms of anaphylaxis.", articleDisclaimer: content.anaphylaxisDisclaimer, articleContent: content.anaphylaxisTips, image: "anaphylaxis")
                .padding(7)
            ArticleRichLink(articleTitle: "OIT Best Practices", articleDescription: "Tips and tricks for Oral Immunotherapy.", articleDisclaimer: content.oitDisclaimer, articleContent: content.oitTips, image: "oit")
                .padding(7)
            ArticleRichLink(articleTitle: "Avoiding Cross Contamination", articleDescription: "Tips to help avoid cross contamination.", articleDisclaimer: content.ccDisclaimer, articleContent: content.crossContaminationTips, image: "crossContamination")
                .padding(7)
        }
    }

    var emergencyServicesInformation: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Emergency Services")
                    .font(.title3).bold()
                    .padding()
                Spacer()
            }
            if #available(iOS 17.0, *) {
                TipView(esTip, arrowEdge: .bottom)
                    .tipCornerRadius(15)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
            }
            Button(action: {
                if let url = URL(string: "tel://911") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Image(systemName: "phone.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                Text("911    ")
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .background(colorScheme == .light ? Color.lightTeal : Color.darkTeal)
            .cornerRadius(10)
        }
    }

    var fareInformation: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Food Allergy Research & Education")
                    .font(.title3).bold()
                    .padding()
                Spacer()
            }
            HStack{
                Button(action: {
                    if let url = URL(string: "https://www.foodallergy.org") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "safari.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                    Text("Website    ")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black)
                }
                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 50)
                .background(colorScheme == .light ? Color.lightTeal : Color.darkTeal)
                .cornerRadius(10)

                Button(action: {
                    if let url = URL(string: "tel://18009294040") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }) {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                    Text("Phone       ")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black)
                }
                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 50)
                .background(colorScheme == .light ? Color.lightTeal : Color.darkTeal)
                .cornerRadius(10)
            }
        }
    }

    var doctorClinicInformation: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Doctor / Clinic Contact")
                    .font(.title3).bold()
                    .padding()
                Spacer()
            }
            if #available(iOS 17.0, *) {
                TipView(doctorTip, arrowEdge: .bottom)
                    .tipCornerRadius(15)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
            }
            TextField("Enter Doctor Phone Number", text: $doctorPhoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            Button(action: {
                if let url = URL(string: "tel://\(doctorPhoneNumber)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Image(systemName: "phone.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                Text("Doctor Phone Number")
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .background(colorScheme == .light ? Color.lightTeal : Color.darkTeal)
            .cornerRadius(10)
        }
    }

    var relevantDocuments: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Important Documents")
                    .font(.title3).bold()
                    .padding()
                Spacer()
            }
            if #available(iOS 17.0, *) {
                TipView(infoTip, arrowEdge: .bottom)
                    .tipCornerRadius(15)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
            }
            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("Select Images")
                    .font(.body)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
            .background(colorScheme == .light ? Color.lightTeal : Color.darkTeal)
            .cornerRadius(10)
            .padding()
            .sheet(isPresented: $isShowingImagePicker) {
                MultiImagePicker(selectedImages: $selectedImages)
            }

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                    ForEach(selectedImages.indices, id: \.self) { index in
                        VStack {
                            NavigationLink(destination: Image(uiImage: selectedImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .navigationBarTitle("", displayMode: .inline)
                            ) {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width / 3 - 15, height: UIScreen.main.bounds.width / 3 - 15)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                selectedImages.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .background(colorScheme == .light ? Color.lightGrey : Color.darkGrey)
                                    .clipShape(Circle())
                                    .padding(1)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3 - 15, height: 30, alignment: .center)
                        }
                    }
                }
                .padding()
            }
        }
    }

    // MARK: Education Tab View
    var body: some View {
        VStack(alignment: .leading) {
            Text("Resources")
                .font(.largeTitle.bold())
                .padding()
            ScrollView {
                if #available(iOS 17.0, *) {
                    TipView(resourcesTip, arrowEdge: .none)
                        .tipCornerRadius(15)
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                }
                articles
                emergencyServicesInformation
                doctorClinicInformation
                fareInformation
                relevantDocuments
            }
        }
        .padding(.bottom, 20)
        .task {
            if #available(iOS 17.0, *) {
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
            }
        }
        .onAppear {
            // Load saved images from UserDefaults
            if let data = UserDefaults.standard.data(forKey: "selectedImages") {
                do {
                    storedImageData = try JSONDecoder().decode([ImageData].self, from: data)
                    selectedImages = []
                    // Convert stored data to UIImage
                    for imageData in storedImageData {
                        if let image = UIImage(data: imageData.imageData) {
                            selectedImages.append(image)
                        }
                    }
                } catch {
                    print("Error decoding images: \(error)")
                }
            }
        }
        .onDisappear {
            // Save selected images to UserDefaults
            do {
                storedImageData.removeAll()
                for image in selectedImages {
                    if let imageData = image.jpegData(compressionQuality: 0.5) {
                        storedImageData.append(ImageData(imageData: imageData))
                    }
                }
                let encodedData = try JSONEncoder().encode(storedImageData)
                UserDefaults.standard.set(encodedData, forKey: "selectedImages")
            } catch {
                print("Error encoding images: \(error)")
            }
        }
    }
}

// MARK: Preview
#Preview {
    EducationView()
}
