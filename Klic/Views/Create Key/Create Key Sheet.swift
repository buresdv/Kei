//
//  Create Key sheet.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct CreateKeySheet: View {
    
    @State private var passphrase: String = ""
    @State private var keyName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10)
        {
            Form {
                TextField("Name:", text: $keyName)
                TextField("Passphrase:", text: $passphrase)
            }
            
            HStack
            {
                DismissSheetButton()
                
                Spacer()
                
                CreateKeyButton(labelStyle: .textOnly, keyName: keyName, passphrase: passphrase)
                    .keyboardShortcut(.defaultAction)
                    .disabled(keyName.isEmpty)
            }
        }
        .padding()
        .frame(width: 250)
    }
}

#Preview {
    CreateKeySheet()
}
