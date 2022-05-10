//
//  HomeStore.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI
import ComposableArchitecture

struct HomeState: Equatable {
    enum State: Equatable {
        case game
        case difficulty
        case loading
        case error(AppError)
    }

    @BindableState var difficulty: Difficulty = .apprentice

    enum Difficulty: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }

        case apprentice = "Apprentice (0-7 digit)"
        case master = "Master (0-9 digit)"
    }


    var state: State = .difficulty
    var gameState: GameState?

    var unallowedDigits: [String] {

        switch difficulty {

        case .apprentice:
            return ["8", "9"]

        case .master:
            return []

        }
    }
}

enum HomeAction: Equatable, BindableAction {

    case onAppear
    case binding(BindingAction<HomeState>)
    case fetchRandomNumber
    case randomNumberResponse(Result<Int, AppError>)
    case game(GameAction)
}




struct HomeEnvironment {
    let apiClient: APIClient
    let hapticClient: HapticClient
}

extension HomeEnvironment {
    static var live = Self(
        apiClient: .live,
        hapticClient: .live
    )
}

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            return .none

        case .binding:
            return .none

        case .fetchRandomNumber:
            state.state = .loading
            return environment.apiClient.fetchRandomNumber().map(HomeAction.randomNumberResponse)

        case .randomNumberResponse(let result):
            switch result {
            case .success(let number):
                guard String(number).map(String.init)
                    .filter({ !state.unallowedDigits.contains($0) })
                    .removeDuplicates().count == 4 else {
                    return .init(value: .fetchRandomNumber)
                }
                if number >= 0123 && number <= 9876 {
                    state.state = .game
                    state.gameState = .init(answer: number)
                } else {
                    state.state = .error(.apiError)
                }

            case .failure(let error):
                state.state = .error(error)
            }
            return .none

        case .game(.restart):
            return .init(value: .fetchRandomNumber)

        case .game:
            return .none


        }
    }
    .binding(),
    gameReducer.optional().pullback(
        state: \.gameState,
        action: /HomeAction.game,
        environment: {
            .init(
                hapticClient: $0.hapticClient
            )
        }
    )
)

