//
//  Library.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/7/22.
//

import SwiftUI
import Foundation
import SwiftyBeaver
import ComposableArchitecture

struct LibraryClient {
    let initializeLogger: () -> Effect<Never, Never>
}

extension LibraryClient {
    static let live = Self(
        initializeLogger: {
            .fireAndForget {
                let file = FileDestination()
                let console = ConsoleDestination()
                let format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M $X"

                file.format = format
                file.logFileAmount = 10
                file.calendar = Calendar(identifier: .gregorian)
                file.logFileURL = (
                    try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    )
                )?
                .appendingPathComponent("logs")
                .appendingPathComponent("Mastermind.log")

                console.format = format
                console.calendar = Calendar(identifier: .gregorian)
                console.asynchronously = false
                console.levelColor.verbose = "😪"
                console.levelColor.warning = "⚠️"
                console.levelColor.error = "‼️"
                console.levelColor.debug = "🐛"
                console.levelColor.info = "📖"

                SwiftyBeaver.addDestination(file)
                #if DEBUG
                SwiftyBeaver.addDestination(console)
                #endif

            }
        }
    )
}

