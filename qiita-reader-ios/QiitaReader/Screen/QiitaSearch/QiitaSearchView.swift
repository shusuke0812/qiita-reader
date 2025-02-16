//
//  ContentView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

struct QiitaSerachView<ViewModel: QiitaSearchViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            Text("Qiita")
        }
        .searchable(text: $viewModel.input.query)
        .onSubmit(of: .search) {
            viewModel.input.searchItems()
        }
    }
}

#Preview {
    QiitaSerachView(viewModel: QiitaSearchViewModel())
}
