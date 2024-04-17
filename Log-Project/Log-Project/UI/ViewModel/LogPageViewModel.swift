//
//  LogPageViewModel.swift
//  Log-Project
//
//  Created by Uğur Polat on 4.04.2024.
//

import Foundation

class LogPageViewModel {
    
    var logList:Observable<[Log]> = Observable()
    var sqliteClient = SQLiteClient()
    
    init() {
        sqliteCopy()
        logList.value = sqliteClient.getLogs()
        getLogs()
    }
    
    func getLogs() {
        self.logList.value = sqliteClient.getLogs()
    }
    
    func deleteLog(log_id:Int) {
        sqliteClient.deleteLog(log_id: log_id)
        getLogs()
    }
    
    
    
    
    func sqliteCopy() {
        let bundlePath = Bundle.main.path(forResource: "log", ofType: ".sqlite")
        let targetPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let copyPath = URL(fileURLWithPath: targetPath).appendingPathComponent("log.sqlite")
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: copyPath.path) {
            print("Sqlite is already exits.")
        } else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: copyPath.path)
            } catch  {
                
            }
        }
    }
}
