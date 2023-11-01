//
//  SSH Key.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation

struct SSHKey: Identifiable, Equatable, Hashable
{
    var id: String { publicKey }
    
    let name: String
    
    let privateKey: String
    let publicKey: String
    
    let url: URL
    
    let createdAt: Date
}
