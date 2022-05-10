//
//  HomeView.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    private let store: Store<HomeState, HomeAction>
    @ObservedObject private var viewStore: ViewStore<HomeState, HomeAction>

    init(store: Store<HomeState, HomeAction>) {
        self.store = store
        viewStore = .init(store)
    }

    var body: some View {
        NavigationView {
            VStack {
                switch viewStore.state.state {
                case .game:
                    IfLetStore(
                        store.scope(state: \.gameState, action: HomeAction.game),
                        then: GameView.init
                    )


                case .loading:
                    ProgressView("Loading...")

                case .error(let error):
                    Text("Something went wrong. (\(String(describing: error)))")
                    Button("Retry") {
                        viewStore.send(.fetchRandomNumber)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                    .textCase(.uppercase)
                    .padding()

                case .difficulty:
                    VStack {

                        VStack(spacing: 5) {
                            Text("Choose a difficulty level: ")
                            Text("Apprentice with range 0-7")
                            Text("Master with range 0-9")
                        }
                        .padding()

                        VStack(spacing: 30) {
                            Picker("Choose difficulty", selection: viewStore.binding(\.$difficulty))
                            {
                                ForEach(HomeState.Difficulty.allCases, id: \.id) {
                                    Text($0.rawValue).tag($0)
                                }

                            }
                            .pickerStyle(SegmentedPickerStyle())
//                            Text("Current level - \(viewStore.difficulty.rawValue)")


                            Button("Start") {
                                viewStore.send(.fetchRandomNumber)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("MasterBlue"), Color("AboutToShine")]), startPoint: .leading, endPoint: .trailing))
                            .buttonBorderShape(.capsule)
                            .cornerRadius(40)
                            .buttonStyle(.bordered)
                            .textCase(.uppercase)

                        }
                        .padding()

                    }
                    .padding()
                }
            }
            .animation(.default, value: viewStore.gameState)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle("Mastermind")
        }
        .navigationViewStyle(.stack)
    }
}

