//
//  ArticleDetailView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

import SwiftUI

struct ArticleDetailView<ViewModel: ArticleDetailViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 2) {
            if viewModel.output.isLoading {
                ProgressView()
            }
            WebView(isLoading: $viewModel.output.isLoading, articleUrl: viewModel.output.articleUrl)
        }
    }
}

#Preview {
    ArticleDetailView(viewModel: ArticleDetailViewModel(articleUrlString: "https://developer.apple.com/jp/"))
}
