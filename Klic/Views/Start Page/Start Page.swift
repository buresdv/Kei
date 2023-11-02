//
//  Start Page.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct StartPage: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var keyTracker: KeyTracker
    
    var body: some View {
        VStack(alignment: .center, spacing: 10)
        {
            if appState.isLoadingKeys
            {
                ProgressView {
                    Text("Loading keys…")
                }
            }
            else
            {
                if !keyTracker.keys.isEmpty
                {
                    KeyCounterView()
                }
                else
                {
                    Image(systemName: "key.horizontal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .foregroundColor(Color(nsColor: .lightGray))
                    
                    Text("You don't have any SSH keys")
                    
                    DisplayKeyAdditionSheetButton(labelStyle: .textOnly)
                }
            }
        }
        .padding()
    }
}
