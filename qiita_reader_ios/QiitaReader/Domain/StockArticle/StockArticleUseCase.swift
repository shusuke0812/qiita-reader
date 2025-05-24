//
//  StockArticleUseCase.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/5/22.
//

import Combine
import Foundation

protocol StockArticleUseCaseProtocol {
    func invoke(itemId: String) -> AnyPublisher<Void, SignInError>
}

class StockArticleUseCase: StockArticleUseCaseProtocol {
    private let validateUserCredentialUseCase: ValidateUserCredentialUseCaseProtocol
    private let signInUseCase: SignInUseCaseProtocol

    init(
        validateUserCredentialUseCase: ValidateUserCredentialUseCaseProtocol = ValidateUserCredentialUseCase(),
        signInUseCase: SignInUseCaseProtocol = SignInUseCase()
    ) {
        self.validateUserCredentialUseCase = validateUserCredentialUseCase
        self.signInUseCase = signInUseCase
    }
    // TODO: 未ログインの場合はログイン画面を表示. ログイン済みかつストック済みである場合はストック削除メソッドを呼ぶ
    // TODO: エラー型をStockErrorに修正する
    func invoke(itemId: String) -> AnyPublisher<Void, SignInError> {
        if validateUserCredentialUseCase.isValid {
            return Just<Void>(())
                .setFailureType(to: SignInError.self)
                .eraseToAnyPublisher()
        }
        return signInUseCase.signIn()
    }
}
