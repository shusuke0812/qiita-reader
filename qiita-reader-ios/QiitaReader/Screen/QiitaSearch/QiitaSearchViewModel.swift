//
//  QiitaSearchViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/15.
//

import Combine
import Foundation

class QiitaSearchViewModel: ObservableObject {
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
