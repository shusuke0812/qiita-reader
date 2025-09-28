//
//  ArticleSearch.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/9/28.
//

import XCTest
import SwiftUI
@testable import QiitaReader

class ArticleSearch: ScreenObjectable {
    enum A11y {
        static let standbyViewId = "article_search_standby_view"
        static let errorViewId = "error_view"
        static let standbyTitleKey = "article_search_stanby_title"
        static let errorTitleKey = "common_error"
    }

    // MARK: UIElement
    var screenTitle: XCUIElement? {
        nil
    }

    func getStandbyTitleText() -> String? {
        guard standbyView.waitForExistence(timeout: 5) else { return nil }
        return standbyTitle.label
    }

    func getErrorTitleText() -> String? {
        guard errorView.waitForExistence(timeout: 5) else { return nil }
        return errorTitle.label
    }

    private var standbyView: XCUIElement {
        app.otherElements[A11y.standbyViewId]
    }

    private var standbyTitle: XCUIElement {
        standbyView.staticTexts[A11y.standbyTitleKey]
    }

    private var errorView: XCUIElement {
        app.otherElements[A11y.errorViewId]
    }

    private var errorTitle: XCUIElement {
        errorView.staticTexts[A11y.errorTitleKey]
    }
}
