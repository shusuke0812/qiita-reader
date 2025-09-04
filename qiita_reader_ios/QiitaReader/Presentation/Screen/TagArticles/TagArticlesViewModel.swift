//
//  TagArticlesViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Combine
import Foundation

protocol TagArticlesViewModelInput {
    func searchItems(tagId: String)
}

protocol TagArticlesViewModelOutput {
    var itemList: TagItemList { get }
    var tag: Tag { get }
    var errorMessage: String? { get }
}

protocol TagArticlesViewModelProtocol: ObservableObject {
    var input: TagArticlesViewModelInput { get }
    var output: TagArticlesViewModelOutput { get }
}

class TagArticlsViewModel: TagArticlesViewModelProtocol, TagArticlesViewModelInput, TagArticlesViewModelOutput {
    var input: TagArticlesViewModelInput { self }
    var output: TagArticlesViewModelOutput { self }

    // MARK: Output
    @Published var itemList: TagItemList = TagItemList(list: [])
    @Published var tag: Tag = Tag(id: "", iconUrlString: "", followersCount: 0, itemsCount: 0)
    @Published var errorMessage: String?

    private let loadTagArticlesUseCase: LoadTagArticlesUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1

    init(
        tagId: String,
        loadTagArticlesUseCase: LoadTagArticlesUseCaseProtocol = LoadTagArticlesUseCase()
    ) {
        self.loadTagArticlesUseCase = loadTagArticlesUseCase
        self.searchItems(tagId: tagId)
    }

    func searchItems(tagId: String) {
        loadTagArticlesUseCase.invoke(tagId: tagId, page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.descriptionLocalizedKey
                }
            }, receiveValue: { [weak self] tagArticle in
                self?.tag = tagArticle.tag
                self?.itemList = tagArticle.itemList
            })
            .store(in: &cancellables)
    }
}
