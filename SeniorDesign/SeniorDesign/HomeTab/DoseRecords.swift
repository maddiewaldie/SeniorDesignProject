//
//  DoseRecords.swift
//  SeniorDesign
//
//  Created by Maddie on 12/28/23.
//

import Foundation

struct AntihistamineDose: Hashable {
    let name: String
    let dose: String
}

class AntihistamineDoseTransformer: NSSecureUnarchiveFromDataTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value as? AntihistamineDose ?? AntihistamineDose(name: "", dose: "")) else {
            return nil
        }
        return data as NSData
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AntihistamineDose
    }
}

class DosesTransformer: NSSecureUnarchiveFromDataTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let doses = value as? [String: String],
              let data = try? NSKeyedArchiver.archivedData(withRootObject: doses, requiringSecureCoding: false) else {
            return nil
        }
        return data as NSData
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data,
              let doses = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String] else {
            return nil
        }
        return doses
    }
}


class SelectedAllergensTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSSet.self]
    }
}
