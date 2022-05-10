//
//  HapicClient.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/7/22.
//

import SwiftUI
import ComposableArchitecture

struct HapticClient {
    let generateFeedback: (UIImpactFeedbackGenerator.FeedbackStyle) -> Effect<Never, Never>
    let generateNotificationFeedback: (UINotificationFeedbackGenerator.FeedbackType) -> Effect<Never, Never>
}

extension HapticClient {
    static let live: Self = .init(
        generateFeedback: { style in
            .fireAndForget {
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
        },
        generateNotificationFeedback: { style in
            .fireAndForget {
                UINotificationFeedbackGenerator().notificationOccurred(style)
            }
        }
    )
}

