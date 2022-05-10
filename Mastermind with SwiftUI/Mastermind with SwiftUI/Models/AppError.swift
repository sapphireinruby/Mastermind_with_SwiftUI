//
//  AppError.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import Foundation

enum AppError: Error, Equatable {
    case unknown
    case apiError
    case decodingFailed
    case networkingFailed
}
