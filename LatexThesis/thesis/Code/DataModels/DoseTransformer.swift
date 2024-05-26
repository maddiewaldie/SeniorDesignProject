//
//  DoseRecords.swift
//  SeniorDesign
//
//  Created by Maddie on 12/28/23.
//

import Foundation

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
