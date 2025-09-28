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
        static let screenKey = "article_search_view"
    }

    // MARK: UIElement
    var screen: XCUIElement {
        app.otherElements[A11y.screenKey]
    }
}
