//
//  RootView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

import SwiftUI

struct RootView<Content: View>: View {
    @StateObject var router: Router = Router()

    private let content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
    }
}
