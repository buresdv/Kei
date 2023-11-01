//
//  Folder Observer.swift
//  Cork
//
//  Created by David Bureš on 06.10.2023.
//  Original implementation by Daniel Saidi: https://github.com/danielsaidi/SwiftUIKit/blob/master/Sources/SwiftUIKit/Files/FolderMonitor.swift

import Foundation

/// Monitor changes of a folder
public class FolderMonitor
{
    /**
     Create an instance that monitors file system changes in
     a folder at the provided `folderUrl`.
     
     - Parameters:
     - folderUrl: The url of the folder to observe.
     - onChange: The function to call when the folder changes.
     */
    public init(
        folderUrl: URL,
        onChange: @escaping () -> Void
    )
    {
        self.folderUrl = folderUrl
        self.onChange = onChange
    }
    
    private let folderUrl: URL
    private let onChange: () -> Void
    
    private var fileDescriptor: CInt = -1
    private let monitorQueue = DispatchQueue(label: "FolderMonitorQueue", attributes: .concurrent)
    private var monitorSource: DispatchSourceFileSystemObject?
    
    /// Start monitoring changes
    public func startMonitoring()
    {
        guard
            monitorSource == nil,
            fileDescriptor == -1
        else { return }
        
        // Open the directory referenced by URL for monitoring only.
        fileDescriptor = open(folderUrl.path, O_EVTONLY)
        
        // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
        monitorSource = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .write,
            queue: monitorQueue
        )
        
        // Define the block to call when a file change is detected.
        monitorSource?.setEventHandler
        { [weak self] in
            self?.onChange()
        }
        
        // Define a cancel handler to ensure the directory is closed when the source is cancelled.
        monitorSource?.setCancelHandler
        { [weak self] in
            guard let self = self else { return }
            close(self.fileDescriptor)
            self.fileDescriptor = -1
            self.monitorSource = nil
        }
        
        // Start monitoring the directory via the source.
        monitorSource?.resume()
    }
    
    /// Stop monitoring
    public func stopMonitoring()
    {
        monitorSource?.cancel()
    }
}

public class FolderObservable: ObservableObject
{
    /**
     Create an instance that observes file system changes in
     a folder at the provided `folderUrl`.
     
     - Parameters:
     - folderUrl: The folder to observe.
     - fileManager: The file manager to use, by default `.default`.
     */
    public init(
        folderUrl: URL,
        fileManager: FileManager = .default
    )
    {
        self.folderUrl = folderUrl
        self.fileManager = fileManager
        folderMonitor.startMonitoring()
        handleChanges()
    }
    
    /**
     The latest fetched files in the folder.
     */
    @Published
    public var files: [URL] = []
    
    private let folderUrl: URL
    private let fileManager: FileManager
    
    private lazy var folderMonitor = FolderMonitor(
        folderUrl: folderUrl,
        onChange: handleChanges
    )
}

private extension FolderObservable
{
    func handleChanges()
    {
        let files = try? fileManager.contentsOfDirectory(
            at: folderUrl,
            includingPropertiesForKeys: nil,
            options: .producesRelativePathURLs
        )
        
        DispatchQueue.main.async
        {
            self.files = files ?? []
        }
    }
}
