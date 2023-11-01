//
//  Key Tracker.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation

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
            let contentsOfKeyDirectory: [URL] = try FileManager.default.contentsOfDirectory(at: AppConstants.sshKeyDirectory, includingPropertiesForKeys: [.isDirectoryKey])
            
            print("Keys: \(contentsOfKeyDirectory)")
        }
        catch let error
        {
            print("Error while loading keys: \(error.localizedDescription)")
        }
    }
}
