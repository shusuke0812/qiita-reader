//
//  TagItemList.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/22.
//

import Foundation

struct TagItemList {
    let list: [TagItem]

    init(list: [TagItem]) {
        self.list = list
    }

    func add(items: [Item]) -> Self {
        let list = self.list + items
        return TagItemList(list: list)
    }
}
