//
//  GameStore.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct GameState: Equatable {

    enum FocusedDigit {
        case one
        case two
        case three
        case four
    }

    enum State: Equatable {
        case win
        case lose
        case gaming
    }

    struct History: Equatable, Identifiable {
        var id: UUID = .init()
        let value: String
    }

    let answer: Int
    var answerDigits: [String] {
        String(answer).map(String.init)
    }
    var chances = 10
    var state: State = .gaming

    @BindableState var digit1 = ""
    @BindableState var digit2 = ""
    @BindableState var digit3 = ""
    @BindableState var digit4 = ""
    var digits: [String] {
        [digit1, digit2, digit3, digit4]
    }
    var userInput: Int? {
        guard digits.removeDuplicates().count == 4,
              let userInput = Int(digits.joined()),
              userInput >= 0123 && userInput <= 9876
        else { return nil }
        return userInput
    }

    @BindableState var focusedDigit: FocusedDigit?

    var histories = IdentifiedArrayOf<History>()

    @BindableState var confettiTrigger: Int = .zero
}

enum GameAction: Equatable, BindableAction {
    case binding(BindingAction<GameState>)
    case guess
    case guessResult(Bool, String)
    case gameOver(Bool)
    case restart
}

struct GameEnvironment {
    let hapticClient: HapticClient
}

extension GameEnvironment {
    static let live = Self(
        hapticClient: .live
    )
}

let gameReducer = Reducer<GameState, GameAction, GameEnvironment> { state, action, environment in
    switch action {
    case .binding(\.$digit1):
        if !state.digit1.isEmpty {
            state.focusedDigit = .two
        }
        return .none

    case .binding(\.$digit2):
        if !state.digit2.isEmpty {
            state.focusedDigit = .three
        }
        return .none

    case .binding(\.$digit3):
        if !state.digit3.isEmpty {
            state.focusedDigit = .four
        }
        return .none

    case .binding:
        return .none

    case .guess:
        var aCount = 0
        var bCount = 0

        state.answerDigits.enumerated().forEach { (index, element) in
            if state.digits[index] == element {
                aCount += 1
            } else if state.digits.contains(element) {
                bCount += 1
            }
        }
        let historyValue = [state.digits.joined(), "\(aCount)A\(bCount)B"].joined(separator: " match result: ")

        state.digit1 = .init()
        state.digit2 = .init()
        state.digit3 = .init()
        state.digit4 = .init()
        state.chances -= 1

        return .init(value: .guessResult(aCount == 4, historyValue))

    case .guessResult(let didWin, let historyValue):
        var effects: [Effect<GameAction, Never>] = [
            environment.hapticClient.generateNotificationFeedback(didWin ? .success : .error).fireAndForget()
        ]
        if didWin {
            effects.append(.init(value: .gameOver(true)))
        } else if state.chances <= 0 {
            effects.append(.init(value: .gameOver(false)))
        }
        state.histories.append(.init(value: historyValue))
        state.focusedDigit = didWin ? nil : .one
        return .merge(effects)

    case .gameOver(let didWin):
        if didWin {
            state.confettiTrigger += 1
        }
        state.state = didWin ? .win : .lose
        state.focusedDigit = nil
        return .none

    case .restart:
        return .none
    }
}
.binding()
