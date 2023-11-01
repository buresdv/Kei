//
//  ContentView.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct ContentView: View
{
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var keyTracker: KeyTracker
    
    var body: some View
    {
        NavigationSplitView(columnVisibility: $appState.splitViewColumnVisibility) {
            SidebarView()
        } detail: {
            StartPage()
                .navigationDestination(for: SSHKey.self, destination: { key in
                    Text(key.publicKey)
                })
        }
        .toolbar
        {
            DisplayKeyAdditionSheetButton(labelStyle: .iconOnly)
        }
        .onChange(of: keyTracker.keys)
        { newValue in
            if keyTracker.keys.isEmpty
            {
                withAnimation {
                    appState.splitViewColumnVisibility = .detailOnly
                }
            }
            else
            {
                withAnimation {
                    appState.splitViewColumnVisibility = .all
                }
            }
        }
    }
}
