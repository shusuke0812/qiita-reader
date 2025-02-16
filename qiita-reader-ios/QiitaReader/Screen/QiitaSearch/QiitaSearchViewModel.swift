//
//  QiitaSearchViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Combine
import Foundation

protocol QiitaSearchViewModelInput {
    var itemsPublisher: Published<[Item]>.Publisher { get }
}

protocol QiitaSearchViewModelOutput {
    func searchItems(query: String)
}

protocol QiitaSearchViewModelProtocol: ObservableObject {
    var input: QiitaSearchViewModelInput { get }
    var output: QiitaSearchViewModelOutput { get }
}

class QiitaSearchViewModel: QiitaSearchViewModelProtocol, QiitaSearchViewModelInput, QiitaSearchViewModelOutput  {
    // MARK: Input
    var input: QiitaSearchViewModelInput { self }
    var itemsPublisher: Published<[Item]>.Publisher { $items }

    // MARK: Output
    var output: QiitaSearchViewModelOutput { self }

    @Published private(set) var items: [Item] = []
    private let itemsRepository: ItemsRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(itemsRepository: ItemsRepositoryProtocol = ItemsRepository()) {
        self.itemsRepository = itemsRepository
    }

    func searchItems(query: String) {
        itemsRepository.getItems(page: 1, query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("debug: error \(error)")
                }
            }, receiveValue: { result in
                print("debug: result \(result)")
            })
            .store(in: &cancellables)
    }
}
