//
//  SelectedAllergensTransformer.swift
//  SeniorDesign
//
//  Created by Maddie on 3/7/24.
//

import Foundation

class SelectedAllergensTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSSet.self]
    }
}
