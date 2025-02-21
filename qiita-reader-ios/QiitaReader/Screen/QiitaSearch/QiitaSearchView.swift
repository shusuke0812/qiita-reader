//
//  QiitaSearchView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct QiitaSearchView<ViewModel: QiitaSearchViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.output.itemList.list) { item in
                QiitaSearchItemView(item: item) { tag in
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
    QiitaSearchView(viewModel: QiitaSearchViewModel())
}
