//
//  iShnakiOSUITests.swift
//  iShnakiOSUITests
//
//  Created by Huw Williams on 07/04/2025.
//

import XCTest

final class iShnakiOSTUITest: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
    }
    func navToFourActivityRingView() {
        
        // navigates to Four Activity Ring view
        let fourActivityRingViewButton = app.otherElements["toRingView"]
        
        XCTAssert(fourActivityRingViewButton.waitForExistence(timeout: 5), "ActivityRingView button should exist")
        
        fourActivityRingViewButton.tap()
        
        
        
        
        
        
    }
    func navToWaterView()  {
        
        // navigates to Waterview via Four Activity Ring View
        
        let fourActivityRingViewButton = app.otherElements["toRingView"]
        fourActivityRingViewButton.tap()
        
        let waterViewButton = app.otherElements["toWaterView"]
        
        XCTAssert(waterViewButton.waitForExistence(timeout: 5), "WaterView button should exist")
        
        waterViewButton.tap()
        
        // confirms that test is on WaterView by searching for the title.
        let waterViewTitle = app.staticTexts["Water Consumption"]
        XCTAssert(waterViewTitle.waitForExistence(timeout: 5), "Watertitle should exist")
    }
}
