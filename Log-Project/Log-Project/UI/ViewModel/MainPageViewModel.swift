//
//  MainPageViewModel.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import Foundation

class MainPageViewModel {
    
    var coinList:Observable<[Coin]> = Observable()
    
    func getCoins() {
        
        APIClient().fetch(url: URL(string: "http://api.coincap.io/v2/assets")!) { result in
            switch result {
            case .success(let coins):
                
                DispatchQueue.main.async {  // Ensure UI updates are on the main thread
                    self.coinList.value = coins.map({ coin in
                        var modifiedCoin = coin
                        modifiedCoin.isFavorite = false
                        return modifiedCoin
                    })
                }
                //self.coinList.value = updatedCoins
            case .failure(let error):
                print(error)
            }
        }
        
        
        /*
         let request = URLRequest(url: URL(string: "http://api.coincap.io/v2/assets")!)
         //request.httpMethod = "GET"
         
         URLSession.shared.dataTask(with: request) { data, response, error in
         
         if error != nil || data == nil {
         print("Hata")
         return
         }
         
         do {
         
         let result = try JSONDecoder().decode(CoinResult.self, from: data!)
         
         self.coinList.value = result.data!
         //self.subscribe?(self.coinList)
         
         
         } catch  {
         print(error.localizedDescription)
         }
         
         }.resume()
         */
    }
    
}
