//
//  Log.swift
//  Log-Project
//
//  Created by Uğur Polat on 2.04.2024.
//

import Foundation


enum LogLevel: String {
    case error = "error"
    case warning = "warning"
    case info = "info"
    case debug = "debug"
    case verbose = "verbose"
}


class Log: CustomStringConvertible {
    
    var log_id:Int?
    var log_timestamp:String?
    var log_level:String?
    var log_moduleName:String?
    var log_message:String?
    
    var description: String {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //return "[\(dateFormatter.string(from: log_timestamp!))] [\(log_moduleName!)] [\(log_level!)] \(log_message!)"
        return "[\(log_timestamp!))] [\(log_moduleName!)] [\(log_level!)] \(log_message!)"
    }
    
    
    init() {
        
    }
    
    init(log_id:Int, log_timestamp:String, log_level:String, log_moduleName:String, log_message:String) {
        self.log_id = log_id
        self.log_timestamp = log_timestamp
        self.log_level = log_level
        self.log_moduleName = log_moduleName
        self.log_message = log_message
    }
    
}



