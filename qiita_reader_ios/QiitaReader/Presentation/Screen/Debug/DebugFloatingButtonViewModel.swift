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

    private let signinUseCase: SignInUseCaseProtocol
    private let signoutUseCase: SignOutUseCaseProtocol

    init(
        signinUseCase: SignInUseCaseProtocol = SignInUseCase(),
        signoutUseCase: SignOutUseCaseProtocol = SignOutUseCase()
    ) {
        self.signinUseCase = signinUseCase
        self.signoutUseCase = signoutUseCase
    }

    private var cancellables: Set<AnyCancellable> = []

    func call() {
//        signinUseCase.signIn()
//            .sink(receiveCompletion: { completion in
//                print(completion)
//            }, receiveValue: { _ in
//            })
//            .store(in: &cancellables)
        signoutUseCase.signOut()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }
}
