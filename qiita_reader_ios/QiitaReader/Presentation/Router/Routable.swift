//
//  Routable.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/8.
//

import Foundation
import SwiftUI

enum NavigationType {
    case push
    case modal
    case fullScreenModal
    case halfModal
}

protocol Routable: Hashable, Identifiable {
    associatedtype ViewType: View
    func viewToDisplay(router: Router<Self>) -> ViewType
}

extension Routable {
    var id: Self { self }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Route

enum QiitaRoute: Routable {
    case root
    case articleDetail(articleUrlString: String)
    case tagArticles(tagId: String)

    @ViewBuilder
    func viewToDisplay(router: Router<QiitaRoute>) -> some View {
        switch self {
        case .root:
            ArticleSearchView<ArticleSearchViewModel>(
                router: router,
                viewModel: ArticleSearchViewModel()
            )
        case .articleDetail(let urlString):
            ArticleDetailView<ArticleDetailViewModel>(
                router: router,
                viewModel: ArticleDetailViewModel(articleUrlString: urlString)
            )
        case .tagArticles(let tagId):
            TagArticlesView<TagArticlsViewModel>(
                router: router,
                viewModel: TagArticlsViewModel(tagId: tagId)
            )
        }
    }
}
