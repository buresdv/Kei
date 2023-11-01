//
//  Dismiss Sheet Button.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import SwiftUI

struct DismissSheetButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(role: .cancel) {
            dismiss()
        } label: {
            Text("Cancel")
        }
    }
}

#Preview {
    DismissSheetButton()
}
