//
//  ViewModifiers.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI

extension View {
    func synchronize<Value: Equatable>(_ first: Binding<Value>, _ second: Binding<Value>) -> some View {
        self
            .onChange(of: first.wrappedValue) { newValue in
                second.wrappedValue = newValue
            }
            .onChange(of: second.wrappedValue) { newValue in
                first.wrappedValue = newValue
            }
    }
    func synchronize<Value: Equatable>(_ first: Binding<Value>, _ second: FocusState<Value>.Binding) -> some View {
        self
            .onChange(of: first.wrappedValue) { newValue in
                second.wrappedValue = newValue
            }
            .onChange(of: second.wrappedValue) { newValue in
                first.wrappedValue = newValue
            }
    }
}

