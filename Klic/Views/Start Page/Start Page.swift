//
//  Start Page.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct StartPage: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10)
        {
            Image(systemName: "key.horizontal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundColor(Color(nsColor: .lightGray))
            
            Text("You don't have any SSH keys")
            
            DisplayKeyAdditionSheetButton(labelStyle: .textOnly)
        }
        .padding()
    }
}

#Preview {
    StartPage()
}
