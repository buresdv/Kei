//
//  Sidebar.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct SidebarView: View
{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var keyTracker: KeyTracker
    
    var body: some View
    {
        List(selection: $appState.navigationSelection)
        {
            ForEach(keyTracker.keys.sorted(by: { $0.createdAt > $1.createdAt }))
            { key in
                NavigationLink {
                    KeyDetailView(key: key)
                        .id(key.id)
                } label: {
                    Text(key.name)
                }
                .contextMenu
                {
                    Button(action: {
                        Task
                        {
                            await keyTracker.deleteKey(keyURL: key.url)
                        }
                    }, label: {
                        Text("Delete \(key.name)")
                    })
                }
            }
        }
        /*
        .toolbar
        {
            ToolbarItem(id: "homeButton", placement: .automatic) {
                Button {
                    appState.navigationSelection = nil
                } label: {
                    Label("Go to status page", systemImage: "house")
                }
                .help("action.go-to-status-page")
                //.disabled(appState.navigationSelection == nil)
            }
            .defaultCustomization(.visible, options: .alwaysAvailable)
        }
         */
    }
}

#Preview
{
    SidebarView()
}
