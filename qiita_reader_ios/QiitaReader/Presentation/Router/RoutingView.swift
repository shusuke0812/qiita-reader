//
//  RootView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

import SwiftUI

struct RoutingView<Content: View, Destination: Routable>: View where Destination.ViewType == Content {
    @ObservedObject var router: Router<Destination>

    private let content: (Router<Destination>) -> Content

    init(_ router: Router<Destination>, @ViewBuilder content: @escaping (Router<Destination>) -> Content) {
        self.router = router
        self.content = content
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content(router)
                .navigationDestination(for: Destination.self) { route in
                    router.start(route)
                }
        }
        .sheet(item: $router.presentingModal) { route in
            RoutingView(router.factory(routeType: .modal)) { childRouter in
                childRouter.start(route)
            }
        }
    }
}
