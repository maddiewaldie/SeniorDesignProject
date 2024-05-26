//
//  ImportantDocumentsTip.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import TipKit

struct ImportantDocumentsTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Keep Your Information in One Place!")
    }

    var message: Text? {
        Text("Add pictures of important documents, such as your Emergency Action Plan, below, so you can easily find them later!")
    }

    var image: Image? {
        Image(systemName: "doc.richtext")
    }
}
