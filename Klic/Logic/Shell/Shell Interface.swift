//
//  Shell Interface.swift
//  Klic
//
//  Created by David Bureš on 01.11.2023.
//

import Foundation

struct TerminalOutput
{
    var standardOutput: String
    var standardError: String
}

enum StreamedTerminalOutput
{
    case standardOutput(String)
    case standardError(String)
}


@discardableResult
func shell(
    _ launchPath: URL,
    _ arguments: [String],
    environment: [String: String]? = nil
) async -> TerminalOutput
{
    var allOutput: [String] = .init()
    var allErrors: [String] = .init()
    for await streamedOutput in shell(launchPath, arguments, environment: environment)
    {
        switch streamedOutput
        {
            case let .standardOutput(output):
                allOutput.append(output)
            case let .standardError(error):
                allErrors.append(error)
        }
    }
    
    return .init(
        standardOutput: allOutput.joined(),
        standardError: allErrors.joined()
    )
}


/// # Usage:
/// for await output in shell(AppConstants.brewExecutablePath, ["install", package.name])
/// {
///    switch output
///    {
///    case let .output(outputLine):
///        // Do something with `outputLine`
///    case let .error(errorLine):
///        // Do something with `errorLine`
///    }
///}
func shell(
    _ launchPath: URL,
    _ arguments: [String],
    environment: [String: String]? = nil
) -> AsyncStream<StreamedTerminalOutput> {
    let task = Process()
    
    var finalEnvironment: [String: String] = .init()
    
    // MARK: - Set up the $HOME environment variable so brew commands work on versions 4.1 and up
    if var environment
    {
        environment["HOME"] = FileManager.default.homeDirectoryForCurrentUser.path
        finalEnvironment = environment
    }
    else
    {
        finalEnvironment = ["HOME": FileManager.default.homeDirectoryForCurrentUser.path]
    }
    
    task.environment = finalEnvironment
    task.launchPath = launchPath.absoluteString
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    
    let errorPipe = Pipe()
    task.standardError = errorPipe
    
    let inputPipe = Pipe()
    task.standardInput = inputPipe
    
    let fileHandle = FileHandle(fileDescriptor: STDIN_FILENO)
    
    do
    {
        try task.run()
    }
    catch
    {
        print(error)
    }
    
    return AsyncStream { continuation in
        pipe.fileHandleForReading.readabilityHandler = { handler in
            guard let standardOutput = String(data: handler.availableData, encoding: .utf8) else
            {
                return
            }
            
            guard !standardOutput.isEmpty else { return }
            
            continuation.yield(.standardOutput(standardOutput))
        }
        
        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            guard let errorOutput = String(data: handler.availableData, encoding: .utf8) else
            {
                return
            }
            
            guard !errorOutput.isEmpty else { return }
            
            continuation.yield(.standardError(errorOutput))
        }
        
        task.terminationHandler = { _ in
            continuation.finish()
        }
        
        fileHandle.readabilityHandler = { handler in
            let data = handler.availableData
            if data.count > 0
            {
                inputPipe.fileHandleForWriting.write(data)
            }
            
            continuation.yield(.standardOutput("Managed to get an input pipe in"))
        }
    }
}
