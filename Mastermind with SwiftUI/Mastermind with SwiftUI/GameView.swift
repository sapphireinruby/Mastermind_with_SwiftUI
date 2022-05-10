//
//  GameView.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI
import SFSafeSymbols
import ConfettiSwiftUI
import ComposableArchitecture

struct GameView: View {
    private let store: Store<GameState, GameAction>
    @ObservedObject private var viewStore: ViewStore<GameState, GameAction>

    @FocusState private var focusedDigit: GameState.FocusedDigit?

    init(store: Store<GameState, GameAction>) {
        self.store = store
        viewStore = .init(store)
    }

    var body: some View {
        VStack(spacing: 0) {
            List(viewStore.histories.reversed()) { history in
                Text(history.value)
            }
            .confettiCannon(counter: viewStore.binding(\.$confettiTrigger), num: 100)

            Divider()

            VStack(spacing: 10) {
                Text("Remaining chances: \(viewStore.chances)").font(.title3).bold()
                Text("pick 4 differernt numbers").fontWeight(.light)
                    .frame(height: viewStore.state.state == .gaming ? nil : 0)
                    .opacity(viewStore.state.state == .gaming ? 1 : 0)

                ZStack {
                    HStack {
                        DigitField(digit: viewStore.binding(\.$digit1), isSelected: viewStore.focusedDigit == .one)
                            .focused($focusedDigit, equals: .one)
                        DigitField(digit: viewStore.binding(\.$digit2), isSelected: viewStore.focusedDigit == .two)
                            .focused($focusedDigit, equals: .two)
                        DigitField(digit: viewStore.binding(\.$digit3), isSelected: viewStore.focusedDigit == .three)
                            .focused($focusedDigit, equals: .three)
                        DigitField(digit: viewStore.binding(\.$digit4), isSelected: viewStore.focusedDigit == .four)
                            .focused($focusedDigit, equals: .four)
                    }
                    .synchronize(viewStore.binding(\.$focusedDigit), $focusedDigit)
                    .opacity(viewStore.state.state == .gaming ? 1 : 0)

                    Text("Nice play!").font(.largeTitle).bold()
                        .opacity(viewStore.state.state == .win ? 1 : 0)

                    Text("Sorry, you will get it next time!").font(.largeTitle).bold()
                        .opacity(viewStore.state.state == .lose ? 1 : 0)
                }

                ZStack {
                    Button {
                        viewStore.send(.guess)
                    } label: {
                        Image(systemSymbol: .checkmarkCircleFill).tint(Color("MasterBlue"))
                    }
                    .opacity(viewStore.state.state == .gaming ? 1 : 0)
                    .disabled(viewStore.userInput == nil)
                    .imageScale(.large)
                    .font(.largeTitle)
 

                    Button(viewStore.state.state == .win ? "Continue" : "Restart") {
                        viewStore.send(.restart)
                    }
                    .opacity(viewStore.state.state != .gaming ? 1 : 0)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .padding(10)
                    
                }
            }
            .padding()
        }
        .animation(.default, value: viewStore.state.state)
        .animation(.default, value: viewStore.histories)
    }
}

private struct DigitField: View {
    @Binding private var digit: String
    private let isSelected: Bool

    init(digit: Binding<String>, isSelected: Bool) {
        _digit = digit
        self.isSelected = isSelected
    }

    var body: some View {
        TextField("", text: $digit)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .font(.largeTitle)
            .lineLimit(1)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: isSelected ? 2 : 1)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            )
    }
}


