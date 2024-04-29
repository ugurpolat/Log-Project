//
//  Transaction.swift
//  Log-Project
//
//  Created by Uğur Polat on 29.04.2024.
//

import Foundation

struct Transaction:Codable {
    
    let id: String
    let amount:Int
    let name: String
    let price: Double
    let time: String
    let type: String
    
}
