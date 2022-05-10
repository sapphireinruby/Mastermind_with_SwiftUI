//
//  Constants.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import Foundation

struct Constants {
    struct URL {
        static let randomOrg: Foundation.URL = .init(string: "https://www.random.org").forceUnwrapped
        static let randomIntegers: Foundation.URL = randomOrg.appendingPathComponent("integers")
    }
}
