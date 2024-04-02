//
//  Logger.swift
//  Log-Project
//
//  Created by Uğur Polat on 2.04.2024.
//

import Foundation

class Logger: LogLayer {
    
    static let shared = Logger()
    
    func logSaveLocal(logFile: Log, completion: ((Bool, Error?) -> Void)?) {
        
    }
    
    func logSaveServer(logFile: Log, completion: ((Bool, Error?) -> Void)?) {
        
    }
    
    func printLog(logFile: Log) {
        print(logFile.description)
    }
    
    func log(logFile: Log) {
        
    }
    
}
