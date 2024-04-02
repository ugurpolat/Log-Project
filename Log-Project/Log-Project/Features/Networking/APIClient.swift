//
//  Webservice.swift
//  Log-Project
//
//  Created by Uğur Polat on 29.03.2024.
//

import Foundation

enum CoinError : Error {
    case serverError
    case parsingError
}

class APIClient: APIClientProtocol {
    func fetch(url: URL, completion: @escaping (Result<[Coin], CoinError>) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
           
           if error != nil || data == nil {
               completion(.failure(.serverError))
               return
           } else if let data = data {
               do {
                   
                   let result = try? JSONDecoder().decode(CoinResult.self, from: data)
                   if let result = result {
                       completion(.success(result.data!))
                   } else {
                       completion(.failure(.parsingError))
                   }
                   //self.coinList.value = result.data!
                   
               } catch  {
                   print(error.localizedDescription)
               }
           }
       }.resume()
    }
    
    
    /*
    func downloadCurrencies (url: URL, completion: @escaping(Result<[Coin], CoinError>) -> ()){
     URLSession.shared.dataTask(with: url) { data, response, error in
        
        if error != nil || data == nil {
            completion(.failure(.serverError))
            return
        } else if let data = data {
            do {
                
                let result = try? JSONDecoder().decode(CoinResult.self, from: data)
                if let result = result {
                    completion(.success(result.data!))
                } else {
                    completion(.failure(.parsingError))
                }
                //self.coinList.value = result.data!
                
            } catch  {
                print(error.localizedDescription)
            }
        }
    }.resume()
    }
     */
}
