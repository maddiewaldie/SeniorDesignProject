//
//  DoctorPhoneTip.swift
//  SeniorDesign
//
//  Created by Maddie on 3/15/24.
//

import Foundation
import TipKit

struct DoctorPhoneTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Add Important Contact Info")
    }

    var message: Text? {
        Text("Add your doctor's phone number below, so you can easily reach out to them if needed!")
    }

    var image: Image? {
        Image(systemName: "stethoscope.circle.fill")
    }
}
