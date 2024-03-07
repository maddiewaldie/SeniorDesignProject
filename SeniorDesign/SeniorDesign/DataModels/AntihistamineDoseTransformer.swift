//
//  AntihistamineDoseTransformer.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation

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
