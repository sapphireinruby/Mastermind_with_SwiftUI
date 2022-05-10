//
//  AppDelegateStore.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI
import ComposableArchitecture

class AppDelegate: UIResponder, UIApplicationDelegate {
    let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            apiClient: .live,
            hapticClient: .live,
            libraryClient: .live
        )
    )
    lazy var viewStore = ViewStore(store)

    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        viewStore.send(.appDelegate(.onLaunchFinish))
        return true
    }
}

struct AppDelegateState: Equatable {

}

enum AppDelegateAction {
    case onLaunchFinish
}

struct AppDelegateEnvironment {
    let libraryClient: LibraryClient
}

extension AppDelegateEnvironment {
    static let live = Self(
        libraryClient: .live
    )
}

let appDelegateReducer = Reducer<AppDelegateState, AppDelegateAction, AppDelegateEnvironment>.combine(
    .init { _, action, environment in
        switch action {
        case .onLaunchFinish:
            return .merge(
                environment.libraryClient.initializeLogger().fireAndForget()
            )
        }
    }
)
