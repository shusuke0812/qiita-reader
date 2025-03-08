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
}

protocol ArticleSearchViewModelOutput {
    var isLoading: Bool { get set }
    var itemList: ItemList { get }
    var errorMessage: String? { get }
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
    @Published var isLoading: Bool = false
    @Published var itemList: ItemList = ItemList(list: [])
    @Published var errorMessage: String?

    private let itemsRepository: ItemsRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1

    init(itemsRepository: ItemsRepositoryProtocol = ItemsRepository()) {
        self.itemsRepository = itemsRepository
    }

    func searchItems() {
        isLoading = true
        itemsRepository.getItems(page: page, query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.description
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] itemList in
                self?.itemList = itemList
            })
            .store(in: &cancellables)
    }
}
