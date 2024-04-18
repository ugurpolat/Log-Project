//
//  Date.swift
//  Log-Project
//
//  Created by Uğur Polat on 18.04.2024.
//

import Foundation

extension Date {
    
    func getDateAndHours() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: date)
    }
    
    func setStringDateToDate(date:String) -> Date {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = dateFormatter.date(from: dateString)
        
        return date!
        
    }
}
