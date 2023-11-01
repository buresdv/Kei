//
//  View - Conditional Modifiers.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation
import SwiftUI

extension View
{
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View
    {
        if condition
        {
            transform(self)
        }
        else
        {
            self
        }
    }
}
