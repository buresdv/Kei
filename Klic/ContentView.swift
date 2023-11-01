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
        }
        .onChange(of: keyTracker.keys)
        { newValue in
            if keyTracker.keys.isEmpty
            {
                appState.splitViewColumnVisibility = .detailOnly
            }
            else
            {
                appState.splitViewColumnVisibility = .all
            }
        }
    }
}
