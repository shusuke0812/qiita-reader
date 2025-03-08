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
            RoutingView(router) { _ in
                router.start(.root)
            }
        }
    }
}
