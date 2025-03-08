//
//  QiitaReaderApp.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

@main
struct QiitaReaderApp: App {
    @StateObject var router: Router<QiitaRoute> = .init(isPresented: .constant(.none))

    var body: some Scene {
        WindowGroup {
            RootingView(router) { _ in
                ArticleSearchView<ArticleSearchViewModel>(viewModel: ArticleSearchViewModel())
            }
        }
    }
}
