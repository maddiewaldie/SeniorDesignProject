//
//  HealthKitManagerTests.swift
//  OITTests
//
//  Created by Maddie on 4/10/24.
//

import XCTest
@testable import OIT

class HealthKitManagerTests: XCTestCase {
    var healthKitManager: HealthKitManager!

    override func setUp() {
        super.setUp()
        healthKitManager = HealthKitManager()
    }

    override func tearDown() {
        healthKitManager = nil
        super.tearDown()
    }

    func testSymptomImageNeeded() {
        XCTAssertTrue(healthKitManager.symptomImageNeeded("HKCategoryTypeIdentifierConstipation"))
        XCTAssertTrue(healthKitManager.symptomImageNeeded("HKCategoryTypeIdentifierAbdominalCramps"))
        XCTAssertFalse(healthKitManager.symptomImageNeeded("SomeOtherSymptom"))
    }

    @MainActor func testSaveSymptomForDate() {
        let expectation = XCTestExpectation(description: "Symptom data saved successfully")
        let currentDate = Date()
        let symptom = "HKCategoryTypeIdentifierConstipation"
        
        healthKitManager.saveSymptomsToCoreData(for: currentDate, symptoms: [symptom])
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.healthKitManager.fetchSymptomsFromCoreData(for: currentDate).contains(symptom))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testFetchSymptomsForDate() {
        let expectation = XCTestExpectation(description: "Fetched symptom data successfully")
        let currentDate = Date()

        healthKitManager.fetchSymptomsForDate(currentDate) { symptoms in
            XCTAssertNotNil(symptoms)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func testSaveSymptomsToHealthStore()  {
        
    }
}

