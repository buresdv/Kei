//
//  Create Key.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct CreateKeyButton: View
{
    let labelStyle: LabelStyle
    
    let passphrase: String

    @EnvironmentObject var appState: AppState

    var body: some View
    {
        Button
        {
            Task
            {
                let sshKeyAdditionResult = await shell(URL(string: "/usr/bin/ssh-keygen")!, ["-f", AppConstants.sshKeyDirectory.appendingPathComponent("foo", conformingTo: .fileURL).path, "-N", passphrase])
                
                print(sshKeyAdditionResult)
                
                appState.isShowingSSHKeyAdditionSheet = false
            }
        } label: {
            Label
            {
                Text("Create key")
            } icon: {
                Image(systemName: "plus")
            }
            .if(labelStyle == .iconAndText)
            { viewProxy in
                viewProxy
                    .labelStyle(.titleAndIcon)
            }
            .if(labelStyle == .iconOnly)
            { viewProxy in
                viewProxy
                    .labelStyle(.iconOnly)
            }
            .if(labelStyle == .textOnly)
            { viewProxy in
                viewProxy
                    .labelStyle(.titleOnly)
            }
        }
    }
}
