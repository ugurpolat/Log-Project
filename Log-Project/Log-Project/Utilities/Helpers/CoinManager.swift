//
//  CoinManager.swift
//  Log-Project
//
//  Created by Uğur Polat on 22.04.2024.
//

import Foundation

class CoinManager {
    static let shared = CoinManager()
    private let favoritesKey = "Favorites"
    
    var favorites: Set<String> {
        get {
            Set(UserDefaults.standard.stringArray(forKey: favoritesKey) ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: favoritesKey)
        }
    }

    func toggleFavorite(coin: Coin) {
        guard let id = coin.id else { return }

        var currentFavorites = favorites
        if currentFavorites.contains(id) {
            currentFavorites.remove(id)
        } else {
            currentFavorites.insert(id)
        }
        favorites = currentFavorites
    }

    func isFavorite(coin: Coin) -> Bool {
        guard let id = coin.id else { return false }
        return favorites.contains(id)
    }
}
