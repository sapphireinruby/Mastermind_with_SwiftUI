//
//  Reducer_Extension.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI
import SwiftyBeaver
import ComposableArchitecture

typealias Logger = SwiftyBeaver

extension Reducer {
    func logging() -> Self {
        .init { state, action, environment in
            Logger.info(action)
            return run(&state, action, environment)
        }
    }
}
