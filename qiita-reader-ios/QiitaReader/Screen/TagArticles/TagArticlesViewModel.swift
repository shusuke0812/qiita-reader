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
    var itemList: ItemList { get }
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
    @Published var itemList: ItemList = ItemList(list: [])
    @Published var tag: Tag = Tag(id: "", iconUrlString: "", followersCount: 0, itemsCount: 0)
    @Published var errorMessage: String?

    func searchItems(tagId: String) {

    }
}
