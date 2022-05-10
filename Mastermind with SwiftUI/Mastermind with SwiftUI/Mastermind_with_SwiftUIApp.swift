//
//  Mastermind_with_SwiftUIApp.swift
//  Mastermind with SwiftUI
//
//  Created by Amber on 5/3/22.
//

import SwiftUI

@main
struct Mastermind_with_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: appDelegate.store.scope(
                    state: \.homeState,
                    action: AppAction.home
                )
            )
        }
    }
}
