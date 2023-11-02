//
//  Key Counter.swift
//  Klic
//
//  Created by David Bureš on 02.11.2023.
//

import SwiftUI

struct KeyCounterView: View {
    
    @EnvironmentObject var keyTracker: KeyTracker
    
    var body: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Text(keyTracker.keys.count.formatted(.number))
                .contentTransition(.numericText())
                .font(.largeTitle)
            
            Text(keyTracker.keys.count == 1 ? "key available" : "keys available")
        })
        .foregroundColor(.gray)
    }
}
