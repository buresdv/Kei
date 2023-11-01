//
//  Key Tracker.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation
import SwiftUI

@MainActor
class KeyTracker: ObservableObject
{
    @Published var keys: Set<SSHKey> = .init()
    
    func loadKeys() async
    {
        if !FileManager.default.fileExists(atPath: AppConstants.sshKeyDirectory.path)
        {
            print(AppConstants.sshKeyDirectory)
            try! FileManager.default.createDirectory(at: AppConstants.sshKeyDirectory, withIntermediateDirectories: true)
            
            print("No SSH folder. Creating it...")
        }
        else
        {
            print("SSH folder found")
        }
        
        do
        {
            let contentsOfKeyDirectory: [URL] = try FileManager.default.contentsOfDirectory(at: AppConstants.sshKeyDirectory, includingPropertiesForKeys: [.isRegularFileKey, .addedToDirectoryDateKey], options: .skipsHiddenFiles)
            
            let keyURLsWithNoPathExtension: [URL] = contentsOfKeyDirectory.filter { $0.pathExtension.isEmpty }
            
            for keyURL in keyURLsWithNoPathExtension
            {
                let keyAttributes = try! FileManager.default.attributesOfItem(atPath: keyURL.path)
                let keyCreationDate = keyAttributes[FileAttributeKey.creationDate] as! Date
                
                withAnimation {
                    keys.insert(
                        SSHKey(
                            name: getKeyName(for: keyURL),
                            privateKey: try! String(contentsOf: keyURL),
                            publicKey: try! String(contentsOf: keyURL.appendingPathExtension("pub")),
                            url: keyURL,
                            createdAt: keyCreationDate
                        )
                    )
                }
            }
            
        }
        catch let error
        {
            print("Error while loading keys: \(error.localizedDescription)")
        }
    }

    func deleteKey(keyURL: URL) async
    {
        try! FileManager.default.removeItem(at: keyURL)
        try! FileManager.default.removeItem(at: keyURL.appendingPathExtension("pub"))
        
        withAnimation {
            self.keys.remove(self.keys.filter({ $0.url == keyURL }).first!)
        }
    }
    
    private func getKeyName(for url: URL) -> String
    {
        return url.lastPathComponent
    }
}
