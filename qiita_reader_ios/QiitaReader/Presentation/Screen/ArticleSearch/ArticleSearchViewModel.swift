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
    func openTagArticles(tagId: String)
}

protocol ArticleSearchViewModelOutput {
    var isPresentedTagArticle: Bool { get set }
    var itemList: ItemList { get }
    var errorMessage: String? { get }
    var selectedTagId: String { get }
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
    @Published var itemList: ItemList = ItemList(list: [])
    @Published var errorMessage: String?
    @Published var isPresentedTagArticle: Bool = false
    var selectedTagId: String {
        _selectedTagId
    }

    private let itemsRepository: ItemsRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1
    private var _selectedTagId = ""

    init(itemsRepository: ItemsRepositoryProtocol = ItemsRepository()) {
        self.itemsRepository = itemsRepository
    }

    func searchItems() {
        itemsRepository.getItems(page: page, query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.description
                }
            }, receiveValue: { [weak self] itemList in
                self?.itemList = itemList
            })
            .store(in: &cancellables)
    }

    func openTagArticles(tagId: String) {
        _selectedTagId = tagId
        isPresentedTagArticle = true
    }
}
