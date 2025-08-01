//
//  ArticleSearchViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Combine
import Foundation

protocol ArticleSearchViewModelInput {
    var query: String { get set }
    func searchItems()
    func stockItem(_ id: String)
}

protocol ArticleSearchViewModelOutput {
    var viewState: ViewState<ItemList, ArticleSearchError> { get set }
}

protocol ArticleSearchViewModelProtocol: ObservableObject {
    var input: ArticleSearchViewModelInput { get set }
    var output: ArticleSearchViewModelOutput { get set }
}

class ArticleSearchViewModel: ArticleSearchViewModelProtocol, ArticleSearchViewModelInput, ArticleSearchViewModelOutput  {
    var input: ArticleSearchViewModelInput { get { self } set {} }
    var output: ArticleSearchViewModelOutput { get { self} set {} }

    // MARK: Input
    @Published var query: String = ""

    // MARK: Output
    @Published var viewState: ViewState<ItemList, ArticleSearchError>

    private let itemsRepository: ItemsRepositoryProtocol
    private let stockArticleUseCase: StockArticleUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1

    init(
        itemsRepository: ItemsRepositoryProtocol = ItemsRepository(),
        stockArticleUseCase: StockArticleUseCaseProtocol = StockArticleUseCase()
    ) {
        self.itemsRepository = itemsRepository
        self.stockArticleUseCase = stockArticleUseCase
        self.viewState = .standby
    }

    func searchItems() {
        viewState = .loading
        itemsRepository.getItems(page: page, query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.viewState = .failure(ArticleSearchError.apiError(error))
                }
            }, receiveValue: { [weak self] itemList in
                if itemList.list.isEmpty {
                    self?.viewState = .failure(ArticleSearchError.notFoundArticls)
                    return
                }
                self?.viewState = .success(itemList)
            })
            .store(in: &cancellables)
    }

    func stockItem(_ id: String) {
        stockArticleUseCase
            .invoke(itemId: id)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }
}
