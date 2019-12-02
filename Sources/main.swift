#!/usr/bin/env swift

//
//  clear-derived-data.swift
//
//  Created by Ross Butler on 28/11/19.
//  Copyright © 2019 Ross Butler. All rights reserved.
//

import Foundation

struct ClearDerivedData {
    
    private var deletePermanently: Bool = false
    private var echoOn: Bool = true
    
    init() {
        self.deletePermanently = containsSwitch("f")
        self.echoOn = containsSwitch("v")
    }
    
    func run() {
        guard !containsSwitch("h") && !containsSwitch("-help") else {
            printUsage()
            exit(0)
        }
        let derivedData = DerivedData()
        guard !derivedData.isEmpty() else {
            printMessage("DerivedData empty.", ignoringEcho: true)
            exit(0)
        }
        if deletePermanently {
            derivedData.delete()
        } else {
            derivedData.moveToTrash()
        }
        printMessage("DerivedData cleared.", ignoringEcho: true)
        exit(0)
    }
    
    /// Determines whether or not the given parameter was provided as one of the command line args.
    private func containsSwitch(_ switch: String) -> Bool {
        return CommandLine.arguments.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines) == "-\(`switch`)" })
    }

    /// Prints a message if echo enabled.
    private func printMessage(_ message: String, ignoringEcho: Bool = false) {
        guard echoOn || ignoringEcho else { return }
        print(message)
    }
    
    /// Prints tool usage information.
    private func printUsage() {
        print("usage: cdd [-f] [-v]")
    }
    
}

struct DerivedData {
    
    private let fileManager = FileManager.default
    private static let path = expandingTildeInPath("~/Library/Developer/Xcode/DerivedData")
    private static let url = URL(fileURLWithPath: path)
    private let url = DerivedData.url
    
    func delete() {
        removeItem(at: url)
    }
    
    private static func expandingTildeInPath(_ path: String) -> String {
        return path.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
    }
    
    func isEmpty() -> Bool {
        guard let urls = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []) else {
            return true
        }
        return urls.isEmpty
    }
    
    func moveToTrash() {
        trash(at: url)
    }
    
    private func removeItem(at url: URL) {
        try? fileManager.removeItem(at: url)
    }
    
    private func trash(at url: URL) {
        try? fileManager.trashItem(at: url, resultingItemURL: nil)
    }
    
}

let app = ClearDerivedData()
app.run()
