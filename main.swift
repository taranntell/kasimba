import AppKit

// This file is the true entry point for the application.
// It doesn't need the @main attribute because Swift automatically
// recognizes a file named "main.swift" as the entry point.

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv) 