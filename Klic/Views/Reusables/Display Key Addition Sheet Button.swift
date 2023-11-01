//
//  Display Key Addition Sheet Button.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct DisplayKeyAdditionSheetButton: View {
    
    @EnvironmentObject var appState: AppState
    
    let labelStyle: LabelStyle
    
    var body: some View {
        Button
        {
            appState.isShowingSSHKeyAdditionSheet = true
        } label: {
            Label {
                Text("Add key")
            } icon: {
                Image(systemName: "plus")
            }
            .if(labelStyle == .iconAndText) { viewProxy in
                viewProxy
                    .labelStyle(.titleAndIcon)
            }
            .if(labelStyle == .iconOnly) { viewProxy in
                viewProxy
                    .labelStyle(.iconOnly)
            }
            .if(labelStyle == .textOnly) { viewProxy in
                viewProxy
                    .labelStyle(.titleOnly)
            }
        }
    }
}
