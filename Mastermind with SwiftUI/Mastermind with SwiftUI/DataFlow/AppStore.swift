//
//  AppStore.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var appDelegateState = AppDelegateState()
    var homeState = HomeState()
}

enum AppAction {
    case appDelegate(AppDelegateAction)
    case home(HomeAction)
}

struct AppEnvironment {
    let apiClient: APIClient
    let hapticClient: HapticClient
    let libraryClient: LibraryClient
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .appDelegate:
            return .none

        case .home:
            return .none
        }
    },
    appDelegateReducer.pullback(
        state: \.appDelegateState,
        action: /AppAction.appDelegate,
        environment: {
            .init(
                libraryClient: $0.libraryClient
            )
        }
    ),
    homeReducer.pullback(
        state: \.homeState,
        action: /AppAction.home,
        environment: {
            .init(
                apiClient: $0.apiClient,
                hapticClient: $0.hapticClient
            )
        }
    )
)
.logging()
