//
//  ScreenObjectable.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/9/5.
//

import XCTest

protocol ScreenObjectable {
    associatedtype A11y
    var app: XCUIApplication { get }
    var exists: Bool { get }
    var pageTitle: XCUIElement { get }
}

extension ScreenObjectable {
    var app: XCUIApplication {
        XCUIApplication()
    }

    var exists: Bool {
        elementsExist([pageTitle], timeout: 5)
    }

    func elementsExist(_ elements: [XCUIElement], timeout: Double) -> Bool {
        return elements.allSatisfy { element in
            element.waitForExistence(timeout: timeout)
        }
    }
}
