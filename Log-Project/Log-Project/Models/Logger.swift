//
//  Logger.swift
//  Log-Project
//
//  Created by Uğur Polat on 2.04.2024.
//

import Foundation

class Logger: LogLayer {
    
    static let shared = Logger()
    
    private init() {}
    
    func logSaveLocal(logFile: Log, completion: ((Bool, Error?) -> Void)?) {
        print("Log Save Local")
    }
    
    func logSaveServer(logFile: Log, completion: ((Bool, Error?) -> Void)?) {
        print("Log Save Server")
    }
    
    func printLog(logFile: Log) {
        print(logFile.description)
        
    }
    
}
