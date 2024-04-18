//
//  SQLiteLayers.swift
//  Log-Project
//
//  Created by Uğur Polat on 18.04.2024.
//

import Foundation

protocol LogStoring {
    func addLog(log_timestamp: String, log_level: String, log_moduleName: String, log_message: String)
}

protocol LogRetrieving {
    func getLogs() -> [Log]
    func getParticularLog(log_Level: String) -> [Log]
}

protocol LogDeleting {
    func deleteLog(log_id: Int)
}
