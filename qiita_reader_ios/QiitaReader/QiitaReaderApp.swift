//
//  QiitaReaderApp.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/9.
//

import SwiftUI

@main
struct QiitaReaderApp: App {
    @StateObject var router: Router<QiitaRoute> = .init(isPresented: .constant(.none))

    var body: some Scene {
        WindowGroup {
            ZStack {
                RoutingView(router) { _ in
                    router.start(.root)
                }
                // TODO: 端末をシェイクしてデバッグビューを表示させるようにする（React Native Expoをイメージ）
//                DebugFloatingButton<DebugFloatingButtonViewModel>(
//                    viewModel: DebugFloatingButtonViewModel()
//                )
            }
        }
    }
}
