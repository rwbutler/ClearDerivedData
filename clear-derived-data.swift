#!/usr/bin/env swift

//
//  clear-derived-data.swift
//
//  Created by Ross Butler on 28/11/19.
//  Copyright © 2019 Ross Butler. All rights reserved.
//

import Foundation

struct Result {
    let exitCode: Int32
    let output: String?
}

private func containsSwitch(_ switch: String) -> Bool {
    return CommandLine.arguments.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines) == "-\(`switch`)" })
}

private func expandingTildeInPath(_ path: String) -> String {
    return path.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
}

guard !containsSwitch("h") && !containsSwitch("-help") else {
    print("usage: cdd [-f] [-v]")
    exit(0)
}

let deletePermanently = containsSwitch("f")
let echoOn = containsSwitch("v")

@discardableResult
private func shell(_ command: String, dir: String? = nil) -> Result {
    if echoOn {
        print(command)
    }
    let task = Process()
    let pipe = Pipe()
    let handle = pipe.fileHandleForReading
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    if let workingDir = dir {
        task.currentDirectoryURL = URL(fileURLWithPath: workingDir)
    }
    task.arguments = ["-c", command]
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let taskOutputData = handle.readDataToEndOfFile()
    guard let taskOutput = String(data: taskOutputData, encoding: String.Encoding.utf8) else {
        handle.closeFile()
        return Result(exitCode: task.terminationStatus, output: nil)
    }
    let output = taskOutput.trimmingCharacters(in: .whitespacesAndNewlines)
    if output != "", echoOn {
        print("> \(output)")
    }
    return Result(exitCode: task.terminationStatus, output: output)
}

// Ensure that we can cd successfully
let path = expandingTildeInPath("~/Library/Developer/Xcode/DerivedData")
guard let output = shell("pwd", dir: path).output, output == path else {
    exit(1)
}

// Create dir DerivedData in ~./Trash
let trash = expandingTildeInPath("~/.Trash")
if !deletePermanently && shell("mkdir \(trash)/DerivedData > /dev/null 2>&1").exitCode != 0 {
    shell("rm -rf \(trash)/DerivedData")
    shell("mkdir \(trash)/DerivedData")
}

// Determine whether to execute rm or mv
let verboseSwitch = echoOn ? "v" : ""
let command = (deletePermanently) ? "rm -rf *" : "mv -f\(verboseSwitch) ./* \(trash)/DerivedData"
guard let lsOutput = shell("ls", dir: path).output, lsOutput != "" else {
    print("DerivedData empty.")
    exit(0)
}
print("DerivedData cleared.")
let exitCode = shell(command, dir: path).exitCode
exit(exitCode)
