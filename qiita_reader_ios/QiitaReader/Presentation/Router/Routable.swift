//
//  Routable.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/3/8.
//

import Foundation
import SwiftUI

enum NavigationType {
    case push
    case modal
    case fullScreenModal
    case halfModal
}

protocol Routable: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: NavigationType { get }
    func viewToDisplay(router: Router<Self>) -> ViewType
}

extension Routable {
    var id: Self { self }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
