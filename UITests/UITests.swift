//
//  GitHubRunnerHealthAppUITestUITests.swift
//  GitHubRunnerHealthAppUITestUITests
//
//  Created by Paul Shmiedmayer on 11/14/22.
//

import XCTest


final class UITests: XCTestCase {
    func testAddDataToHealthApp() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCUIDevice.shared.press(.home)
        
        addUIInterruptionMonitor(withDescription: "System Dialog") { alert in
            guard alert.buttons["Allow"].exists else {
                XCTFail("Failed not dismiss alert: \(alert.staticTexts.allElementsBoundByIndex)")
                return false
            }
            
            alert.buttons["Allow"].tap()
            return true
        }
        
        let healthApp = XCUIApplication(bundleIdentifier: "com.apple.Health")
        healthApp.terminate()
        healthApp.activate()
        
        if healthApp.staticTexts["Welcome to Health"].exists {
            healthApp.staticTexts["Continue"].tap()
            healthApp.staticTexts["Continue"].tap()
            healthApp.tables.buttons["Next"].tap()
            healthApp.staticTexts["Continue"].tap()
        }
        
        guard healthApp.tabBars["Tab Bar"].buttons["Browse"].waitForExistence(timeout: 3) else {
            XCTFail("Failed to find the Browse button in the Tab Bar: \(healthApp.staticTexts.allElementsBoundByIndex)")
            throw XCTestError(.failureWhileWaiting)
        }
        
        healthApp.tabBars["Tab Bar"].buttons["Browse"].tap()
        
        let screenshot = XCUIScreen.main.screenshot()
        let fullScreenshotAttachment = XCTAttachment(screenshot: screenshot)
        fullScreenshotAttachment.lifetime = .keepAlways
        add(fullScreenshotAttachment)
    }
}
