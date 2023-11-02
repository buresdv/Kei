//
//  Create Key sheet.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct CreateKeySheet: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var keyTracker: KeyTracker
    
    @State private var passphrase: String = ""
    @State private var keyName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10)
        {
            Form {
                LabeledContent {
                    TextField("", text: $keyName)
                } label: {
                    Text("Name:")
                }

                LabeledContent {
                    TextField("", text: $passphrase)
                } label: {
                    VStack(alignment: .trailing, spacing: 3, content: {
                        Text("Passphrase:")
                        Text("Optional")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    })
                }
            }
            
            HStack
            {
                DismissSheetButton()
                    .disabled(appState.isCreatingKey)
                
                Spacer()
                
                if appState.isCreatingKey
                {
                    ProgressView()
                        .frame(width: 10, height: 10)
                        .scaleEffect(0.5)
                }
                
                CreateKeyButton(labelStyle: .textOnly, keyName: keyName, passphrase: passphrase)
                    .keyboardShortcut(.defaultAction)
                    .disabled(keyName.isEmpty || keyTracker.keys.contains(where: { $0.name == keyName }))
            }
        }
        .padding()
        .frame(width: 250)
    }
}
