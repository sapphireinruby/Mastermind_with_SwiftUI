//
//  APIClient.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import Combine
import ComposableArchitecture

struct APIClient {
    let fetchRandomNumber: () -> Effect<Result<Int, AppError>, Never>
}

extension APIClient {
    static let live = Self(
        fetchRandomNumber: {
            URLSession.shared.dataTaskPublisher(
                for: Constants.URL.randomIntegers.appending(
                    queryItems: [
                        "num": "1",
                        "min": "1000",
                        "max": "9999",
                        "col": "1",
                        "base": "10",
                        "format": "plain"
                    ]
                )
            )
            .map(\.data)
            .compactMap({ String(data: $0, encoding: .utf8) })
            .map({ $0.trimmingCharacters(in: .newlines) })
            .compactMap(Int.init)
            .mapError(mapAppError)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .catchToEffect()
        }
    )
}

private func mapAppError(_ error: Error) -> AppError {
    switch error {
    case is URLError:
        return .networkingFailed
    case is DecodingError:
        return .decodingFailed
    default:
        return error as? AppError ?? .unknown
    }
}
