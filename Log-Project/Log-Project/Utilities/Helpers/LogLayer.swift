//
//  LogLayer.swift
//  Log-Project
//
//  Created by Uğur Polat on 2.04.2024.
//

import Foundation

protocol LogLayer: AnyObject {
    func log(logFile: Log)
    func logSaveLocal(logFile:Log, completion: ((Bool,Error?) -> Void)?)
    func logSaveServer(logFile: Log, completion: ((Bool,Error?) -> Void)?)
    func printLog(logFile: Log)
}


extension LogLayer {
    // Provide a default implementation for general logging that decides the logging strategy
        func log(logFile: Log) {
            // Example logic: always print debug and info levels; save errors to server and local
            switch logFile.logLevel {
            case .debug, .info:
                printLog(logFile:logFile)
            case .error:
                logSaveServer(logFile:logFile, completion: nil)
                logSaveLocal(logFile:logFile, completion: nil)
            default:
                logSaveLocal(logFile:logFile, completion: nil)
            }
        }
}
