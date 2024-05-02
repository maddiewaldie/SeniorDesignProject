//
//  HealthKitViewModelTests.swift
//  OITTests
//
//  Created by Maddie on 4/10/24.
//

//
//  HealthKitManagerTests.swift
//  OITTests
//
//  Created by Maddie on 4/10/24.
//

import XCTest
@testable import OIT

class HealthKitViewModelTests: XCTestCase {
    var healthKitViewModel: HealthKitViewModel!

    override func setUp() {
        super.setUp()
        healthKitViewModel = HealthKitViewModel()
    }

    override func tearDown() {
        healthKitViewModel = nil
        super.tearDown()
    }

    func testChangeAuthorizationStatus() {
        XCTAssertFalse(healthKitViewModel.isAuthorized)

        healthKitViewModel.changeAuthorizationStatus()
        XCTAssertTrue(healthKitViewModel.isAuthorized)
    }

    func testSaveDoseRecord() {
//        let doseRecord = DoseRecord(date: Date(), dose: 1) // figure out syntax
//        healthKitViewModel.saveDoseRecord(doseRecord)
        // assert record is saved
    }

    func testFetchDoseRecords() {
        healthKitViewModel.fetchDoseRecords()
        // assert if dose records are fetched successfully
    }

    func testHealthRequest() {
        healthKitViewModel.healthRequest()
        // assert if health request is made successfully
    }


}
