//
//  Router.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

// Ref: https://www.curiousalgorithm.com/post/router-pattern-for-swiftui-navigation

import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case articleSearch
        case articleDetail(articleUrlString: String)
        case tagArticles(tagId: String)
    }

    @Published var path: NavigationPath = NavigationPath()

    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .articleSearch:
            ArticleSearchView(viewModel: ArticleSearchViewModel())
        case .articleDetail(let articleUrlString):
            ArticleDetailView(viewModel: ArticleDetailViewModel(articleUrlString: articleUrlString))
        case .tagArticles(let tagId):
            TagArticlesView(viewModel: TagArticlsViewModel(tagId: tagId))
        }
    }

    func pushTo(_ appRoute: Route) {
        path.append(appRoute)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
