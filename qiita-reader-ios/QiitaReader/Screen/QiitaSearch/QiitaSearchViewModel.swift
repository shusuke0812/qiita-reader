//
//  QiitaSearchViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Combine
import Foundation

protocol QiitaSearchViewModelInput {
    var query: String { get set }
    func searchItems()
}

protocol QiitaSearchViewModelOutput {
    var itemsPublished: Published<ItemList> { get }
    var errorMessagePublished: Published<String?> { get }
}

protocol QiitaSearchViewModelProtocol: ObservableObject {
    var input: QiitaSearchViewModelInput { get set }
    var output: QiitaSearchViewModelOutput { get }
}

class QiitaSearchViewModel: QiitaSearchViewModelProtocol, QiitaSearchViewModelInput, QiitaSearchViewModelOutput  {
    // MARK: Input
    var input: QiitaSearchViewModelInput { get { self } set {} }
    @Published var query: String = ""

    // MARK: Output
    var output: QiitaSearchViewModelOutput { self }
    var itemsPublished: Published<ItemList> { _itemList }
    var errorMessagePublished: Published<String?> { _errorMessage }

    @Published private var itemList: ItemList = ItemList(list: [])
    @Published private var errorMessage: String?

    private let itemsRepository: ItemsRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1

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
}
