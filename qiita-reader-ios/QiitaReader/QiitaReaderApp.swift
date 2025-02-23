//
//  QiitaReaderApp.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

@main
struct QiitaReaderApp: App {
    var body: some Scene {
        WindowGroup {
            RootView {
                ArticleSearchView(viewModel: ArticleSearchViewModel())
            }
        }
    }
}
