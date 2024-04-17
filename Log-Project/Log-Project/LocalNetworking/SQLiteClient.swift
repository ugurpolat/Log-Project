//
//  SQLiteClient.swift
//  Log-Project
//
//  Created by Uğur Polat on 4.04.2024.
//

import Foundation

class SQLiteClient {
    
    let db:FMDatabase?
    
    init() {
        let targetPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseURL = URL(fileURLWithPath: targetPath).appendingPathComponent("log.sqlite")
        db = FMDatabase(path: databaseURL.path)
    }
    
    
    func addLog(log_timestamp: String, log_level: String, log_moduleName: String, log_message: String) {
        
        db?.open()
        
        do {
            try  db!.executeUpdate("insert into Logs (log_timestamp,log_level,log_message,log_moduleName) values (?,?,?,?)", values: [ log_timestamp, log_level, log_message, log_moduleName])
            
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
    }
    
    func getLogs() -> [Log] {
        
        db?.open()
        
        defer {
            db?.close()
        }
        var list = [Log]()
        
        do {
            let result = try db!.executeQuery("SELECT * FROM Logs", values: nil)
           
            while result.next() {
                
                let log = Log(log_id: Int(result.string(forColumn: "log_id"))!,
                              log_timestamp: result.string(forColumn: "log_timestamp")!,
                              log_level: result.string(forColumn: "log_level")!,
                              log_moduleName: result.string(forColumn: "log_moduleName")!,
                              log_message: result.string(forColumn: "log_message")!)
                
                list.append(log)
                
            }
            
        } catch  {
            print(error.localizedDescription)
        }
        
        return list
    }
    
    func deleteLog(log_id:Int) {
        db?.open()
        
        do {
            try db!.executeUpdate("delete from Logs where log_id = ?", values: [log_id])
            
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
}
