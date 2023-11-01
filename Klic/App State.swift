//
//  App State.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation
import SwiftUI

class AppState: ObservableObject
{
    @Published var isShowingSSHKeyAdditionSheet: Bool = false
    
    @Published var sshFolderObserver: FolderObservable?
    
    @Published var splitViewColumnVisibility: NavigationSplitViewVisibility = .detailOnly
}
