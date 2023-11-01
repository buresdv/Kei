//
//  KlicApp.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI
import Combine

@main
struct KlicApp: App
{
    @StateObject var appState: AppState = .init()
    @StateObject var keyTracker: KeyTracker = .init()
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .task(priority: .userInitiated) {
                    await keyTracker.loadKeys()
                    
                    appState.isLoadingKeys = false
                }
                .sheet(isPresented: $appState.isShowingSSHKeyAdditionSheet, content: {
                    CreateKeySheet()
                })
                .environmentObject(appState)
                .environmentObject(keyTracker)
        }
    }
}
