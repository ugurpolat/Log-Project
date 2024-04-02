//
//  WebserviceProtocol.swift
//  Log-Project
//
//  Created by Uğur Polat on 2.04.2024.
//

import Foundation

protocol APIClientProtocol {
    
    func fetch (url: URL, completion: @escaping(Result<[Coin], CoinError>) -> ())
}

// test
