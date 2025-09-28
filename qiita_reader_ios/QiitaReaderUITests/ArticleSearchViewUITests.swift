//
//  ArticleSearchViewUITests.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/9/28.
//

import XCTest

class ArticleSearchViewUITests: XCTestCase {
    private var app: XCUIApplication!
    private let articleSearch = ArticleSearch()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testExistScreen() throws {
        let isExist = articleSearch.exists
        XCTAssertEqual(isExist, true)
    }
}
