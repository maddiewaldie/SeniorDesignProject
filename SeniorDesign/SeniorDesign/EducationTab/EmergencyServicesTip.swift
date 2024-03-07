//
//  EmergencyServicesTip.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation
import TipKit

struct EmergencyServicesTip: Tip, Identifiable {
    var id = UUID()
    var title: Text {
        Text("Emergency Assistance")
    }

    var message: Text? {
        Text("In case of an anaphylactic reaction, don't hesitate to call 911 immediately. Time is crucial. Stay calm, provide your location, and follow dispatcher instructions. Administer epinephrine if available, and if trained to do so.")
    }

    var image: Image? {
        Image(systemName: "phone.badge.checkmark")
    }
}
