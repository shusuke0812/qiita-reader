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
    var itemList: ItemList { get }
    var errorMessage: String? { get }
}

protocol QiitaSearchViewModelProtocol: ObservableObject {
    var input: QiitaSearchViewModelInput { get set }
    var output: QiitaSearchViewModelOutput { get }
}

class QiitaSearchViewModel: QiitaSearchViewModelProtocol, QiitaSearchViewModelInput, QiitaSearchViewModelOutput  {
    var input: QiitaSearchViewModelInput { get { self } set {} }
    var output: QiitaSearchViewModelOutput { self }

    // MARK: Input
    @Published var query: String = ""

    // MARK: Output
    @Published var itemList: ItemList = ItemList(list: [])
    @Published var errorMessage: String?

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
