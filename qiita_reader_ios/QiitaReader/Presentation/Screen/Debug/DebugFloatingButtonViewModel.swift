//
//  DebugFloatingButtonViewModel.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/17.
//

import Combine
import Foundation

protocol DebugFloatingButtonViewModelInput {
    func call()
}

protocol DebugFloatingButtonViewModelOutput {}

protocol  DebugFloatingButtonViewModelProtocol: ObservableObject {
    var input: DebugFloatingButtonViewModelInput { get set }
    var output: DebugFloatingButtonViewModelOutput { get }
}

class DebugFloatingButtonViewModel: DebugFloatingButtonViewModelProtocol, DebugFloatingButtonViewModelInput, DebugFloatingButtonViewModelOutput {
    var input: DebugFloatingButtonViewModelInput { get { self } set {} }
    var output: DebugFloatingButtonViewModelOutput { get { self } }

    init() {
    }

    func call() {
    }
}
