//
//  Foundation_Extension.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import Foundation

// MARK: URL
extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        var components: URLComponents = .init(
            url: self, resolvingAgainstBaseURL: false
        )
        .forceUnwrapped
        if components.queryItems == nil {
            components.queryItems = []
        }
        components.queryItems?.append(contentsOf: queryItems)
        return components.url.forceUnwrapped
    }
    func appending(queryItems: [String: String]) -> URL {
        appending(queryItems: queryItems.map(URLQueryItem.init))
    }
    mutating func append(queryItems: [URLQueryItem]) {
        self = appending(queryItems: queryItems)
    }
    mutating func append(queryItems: [String: String]) {
        self = appending(queryItems: queryItems)
    }
}

extension Optional {
    var forceUnwrapped: Wrapped! {
        if let value = self {
            return value
        }
        Logger.error(
            "Failed in force unwrapping...",
            context: ["type": Wrapped.self]
        )
        return nil
    }
}

// MARK: Array
extension Array {
    func removeDuplicates(by predicate: (Element, Element) -> Bool) -> Self {
        var result = [Element]()
        for value in self {
            if result.filter({ predicate($0, value) }).isEmpty {
                result.append(value)
            }
        }
        return result
    }
    func removeDuplicates(by keyPath: KeyPath<Element, String>) -> Self {
        removeDuplicates(by: { $0[keyPath: keyPath] == $1[keyPath: keyPath] })
    }
    func removeDuplicates() -> Self where Element: Equatable {
        removeDuplicates(by: ==)
    }
}
