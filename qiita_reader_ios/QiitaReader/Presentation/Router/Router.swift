//
//  Router.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

// Ref: https://github.com/obvios/Routing?tab=readme-ov-file

import SwiftUI

class Router<Destination: Routable>: ObservableObject {
    enum Route: Hashable {
        case articleSearch
        case articleDetail(articleUrlString: String)
        case tagArticles(tagId: String)
    }

    @Published var path: NavigationPath = NavigationPath()
    @Published var presentingModal: Destination?
    @Published var presentingFullScreenModal: Destination?
    @Published var isPresented: Binding<Destination?>

    init(isPresented: Binding<Destination?>) {
        self.isPresented = isPresented
    }

    @ViewBuilder func start(_ route: Destination) -> some View {
        route.viewToDisplay(router: self)
    }

    @ViewBuilder func view(for route: Destination, using router: Router<Destination>) -> some View {
        route.viewToDisplay(router: router)
    }

    func pushTo(_ appRoute: Route) {
        path.append(appRoute)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    private func router(routeType: NavigationType) -> Router {
        switch routeType {
        case .push:
            return self
        case .modal:
            return Router(
                isPresented: Binding(
                    get: { self.presentingModal },
                    set: { self.presentingModal = $0 }
                )
            )
        case .fullScreenModal:
            return Router(
                isPresented: Binding(
                    get: { self.presentingModal },
                    set: { self.presentingModal = $0 }
                )
            )
        }
    }
}
