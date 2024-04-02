//
//  Log.swift
//  Log-Project
//
//  Created by Uğur Polat on 2.04.2024.
//

import Foundation


enum LogLevel {
    case error
    case warning
    case info
    case debug
    case verbose
}


class Log: CustomStringConvertible {
    
    var timestamp:Date?
    var logLevel:LogLevel?
    var moduleName:String?
    var logMessage:String?
    
    var description: String {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return "[\(dateFormatter.string(from: timestamp!))] [\(moduleName!)] [\(logLevel!)] \(logMessage!)"
    }
    
    
    init() {
        
    }
    
    init(timestamp:Date = Date(), logLevel:LogLevel, moduleName:String, logMessage:String) {
        self.timestamp = timestamp
        self.logLevel = logLevel
        self.moduleName = moduleName
        self.logMessage = logMessage
    }
    
}



