//
//  Router.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

// Ref: https://github.com/obvios/Routing?tab=readme-ov-file

import SwiftUI

class Router<Destination: Routable>: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var presentingModal: Destination?
    @Published var presentingFullScreenModal: Destination?
    @Published var isPresented: Binding<Destination?>

    init(isPresented: Binding<Destination?>) {
        self.isPresented = isPresented
    }

    @ViewBuilder func start(_ route: Destination) -> Destination.ViewType {
        route.viewToDisplay(router: self)
    }

    @ViewBuilder func view(for route: Destination, using router: Router<Destination>) -> Destination.ViewType {
        route.viewToDisplay(router: router)
    }

    // MARK: - Factory

    func factory(routeType: NavigationType) -> Router {
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

    // MARK: - Screen transition

    func routeTo(_ route: Destination, via navigationType: NavigationType) {
        switch navigationType {
        case .push:
            pushTo(route)
        case .modal:
            presentModal(route)
        case .fullScreenModal:
            presentFullScreenModal(route)
        }
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func dismiss() {
        isPresented.wrappedValue = nil
    }

    // MARK: - Private

    private func pushTo(_ route: Destination) {
        path.append(route)
    }

    private func presentModal(_ route: Destination) {
        self.presentingModal = route
    }

    private func presentFullScreenModal(_ route: Destination) {
        self.presentingFullScreenModal = route
    }
}
