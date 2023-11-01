//
//  App Constants.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation

struct AppConstants
{
    static var sshKeyDirectory: URL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".ssh", conformingTo: .directory)
}
