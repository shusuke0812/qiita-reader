//
//  ArticleDetailViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

import Foundation

protocol ArticleDetailViewModelInput {
}

protocol ArticleDetailViewModelOutput {
    var isLoading: Bool { get set }
    var articleUrl: URL { get }
}

protocol ArticleDetailViewModelProtocol: ObservableObject {
    var input: ArticleDetailViewModelInput { get }
    var output: ArticleDetailViewModelOutput { get set }
}

class ArticleDetailViewModel: ArticleDetailViewModelProtocol, ArticleDetailViewModelInput, ArticleDetailViewModelOutput {
    var input: ArticleDetailViewModelInput { self }
    var output: ArticleDetailViewModelOutput { get { self } set {} }

    // MARK: Output
    @Published var isLoading: Bool = false
    var articleUrl: URL {
        URL(string: articleUrlString)!
    }

    private let articleUrlString: String

    init(articleUrlString: String) {
        self.articleUrlString = articleUrlString
    }
}
