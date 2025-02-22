//
//  ArticleSearchView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct ArticleSearchView<ViewModel: ArticleSearchViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.output.itemList.list) { item in
                ArticleSearchItemView(item: item) { tag in
                    print("debug: tapped: \(tag)")
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
        }
        .searchable(text: $viewModel.input.query)
        .onSubmit(of: .search) {
            viewModel.input.searchItems()
        }
    }
}

#Preview {
    ArticleSearchView(viewModel: ArticleSearchViewModel())
}
