//
//  ArticleSearchView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct ArticleSearchView<ViewModel: ArticleSearchViewModelProtocol>: View {
    @StateObject var router: Router<QiitaRoute> = .init(isPresented: .constant(.none))
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            switch viewModel.output.viewState {
            case .standby:
                standbyView
            case .loading:
                loadingView
            case .success(let itemList):
                articleListView(itemList: itemList)
            case .failure(let error):
                errorView(message: LocalizedStringKey(error.descriptionLocalizedKey))
            }
        }
        .searchable(text: $viewModel.input.query)
        .autocorrectionDisabled()
        .onSubmit(of: .search) {
            viewModel.input.searchItems()
        }
    }

    // MARK: - Content Views

    @ViewBuilder
    private var standbyView: some View {
        ContentUnavailableView(
            LocalizedStringKey("article_search_stanby_title"),
            systemImage: SFSymbol.lassoBadgeSparkes,
            description: Text(LocalizedStringKey("article_search_stanby_subtitle"))
        )
    }

    @ViewBuilder
    private var loadingView: some View {
        ProgressView().padding()
        Spacer()
    }

    @ViewBuilder
    private func articleListView(itemList: ItemList) -> some View {
        List(itemList.list) { item in
            ArticleSearchItemView(
                item: item,
                onSelectedTag: { tagId in
                    router.routeTo(.tagArticles(tagId: tagId), via: .modal)
                },
                onSelectedItem: {
                    router.routeTo(.articleDetail(articleUrlString: item.urlString), via: .push)
                },
                onStockItem: { tagId in
                    viewModel.input.stockItem(tagId)
                }
            )
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }

    @ViewBuilder
    private func errorView(message: LocalizedStringKey) -> some View {
        ContentUnavailableView(
            LocalizedStringKey("common_error"),
            systemImage: SFSymbol.exclamationmarkWarninglightFill,
            description: Text(message)
        )
    }
}

#Preview {
    ArticleSearchView(viewModel: ArticleSearchViewModel())
}
