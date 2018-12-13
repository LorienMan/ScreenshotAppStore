//
//  SnapshotAppstoreUITests.swift
//  SnapshotAppstoreUITests
//
//  Created by Ilya Amelchenkov on 13/12/2018.
//  Copyright © 2018 Aviasales. All rights reserved.
//

import XCTest

class SnapshotAppstoreUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }

    func testExample() {
        let app = XCUIApplication()
        app.tap()
        XCUIDevice.shared.press(XCUIDevice.Button.home)

        let appstoreApp = XCUIApplication(bundleIdentifier: "com.apple.AppStore")
        appstoreApp.activate()
        setupSnapshot(appstoreApp)

        sleep(5)

        let tabBarButtons = appstoreApp.tabBars.buttons.allElementsBoundByIndex
        if tabBarButtons.count > 0 && tabBarButtons.last!.isHittable {
            tabBarButtons.last!.tap()
        }

        let searchField = appstoreApp.searchFields.allElementsBoundByIndex.first!
        searchField.tap()
        if searchField.buttons.allElementsBoundByIndex.count > 0 {
            searchField.buttons.allElementsBoundByIndex.first!.tap()
        }

        appstoreApp.typeText(requestString)
        appstoreApp.keyboards.buttons["Search"].tap()
        sleep(5)

        let collectionViews = appstoreApp.collectionViews.allElementsBoundByIndex
        if collectionViews.count > 0 {
            takeScreenshotsOfVerticalCellContainer(collectionViews[0], screenshotBaseName: "Appstore", containerInsets: UIEdgeInsets(top: 180, left: -10, bottom: -100, right: -100), maxPages: pagesNumber)
        }

        searchField.tap()
        appstoreApp.typeText("random text")
        appstoreApp.keyboards.buttons["Search"].tap()

        sleep(1)

        XCUIDevice.shared.press(.home)
    }

    private func takeScreenshotsOfVerticalCellContainer(_ containerElement: XCUIElement, screenshotBaseName: String, containerInsets: UIEdgeInsets = UIEdgeInsets.zero, maxPages: Int = Int.max) {
        var pageIdx = 1
        snapshot("\(screenshotBaseName)_Page_\(pageIdx)")

        repeat {
            let fromCoordinate = containerElement.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 1)).withOffset(CGVector(dx: 1 + containerInsets.left, dy: -20 + containerInsets.bottom))
            let toCoordinate = containerElement.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: 1 + containerInsets.left, dy: -20 + containerInsets.top))
            fromCoordinate.press(forDuration: 0.01, thenDragTo: toCoordinate)

            pageIdx += 1
            snapshot("\(screenshotBaseName)_Page_\(pageIdx)")
        } while pageIdx < maxPages
    }

}
