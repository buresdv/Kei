//
//  Copy to Clipboard.swift
//  Klic
//
//  Created by David Bureš on 02.11.2023.
//

import Foundation
import AppKit

func copyToClipboard(whatToCopy: String)
{
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    pasteboard.setString(whatToCopy, forType: .string)
}
