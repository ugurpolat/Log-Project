//
//  DetailViewController.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var labelCoinId: UILabel!
    @IBOutlet weak var labelCoinMaxSupply: UILabel!
    @IBOutlet weak var labelCoinSupply: UILabel!
    @IBOutlet weak var labelCoinName: UILabel!
    @IBOutlet weak var labelCoinSymbol: UILabel!
    @IBOutlet weak var labelCoinRank: UILabel!
    @IBOutlet weak var labelCoinVWap24Hr: UILabel!
    @IBOutlet weak var labelCoinChangePercent24Hr: UILabel!
    @IBOutlet weak var labelCoinPriceUsd: UILabel!
    @IBOutlet weak var labelCoinVolumeUsd24Hr: UILabel!
    @IBOutlet weak var labelCoinMarketCapUsd: UILabel!
    
    var coinDetail = Coin()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = coinDetail.name
        
        setCoinData()
        
        // Do any additional setup after loading the view.
    }
    
    func setCoinData() {
        labelCoinId.text = "Id: \(coinDetail.id ?? "-")"
        labelCoinMaxSupply.text = "Max Supply: \(coinDetail.maxSupply ?? "-" )"
        labelCoinSupply.text = "Supply: \(coinDetail.supply ?? "-")"
        labelCoinName.text = "Name: \(coinDetail.name ?? "-")"
        labelCoinSymbol.text = "Symbol: \(coinDetail.symbol ?? "-")"
        labelCoinRank.text = "Rank: \(coinDetail.rank ?? "-")"
        labelCoinVWap24Hr.text = "Market Cap Usd: \(coinDetail.vwap24Hr ?? "-")"
        labelCoinChangePercent24Hr.text = "Volume Usd 24Hr: \(coinDetail.vwap24Hr ?? "-")"
        labelCoinPriceUsd.text = "Price Usd: \(coinDetail.priceUsd ?? "-")"
        labelCoinVolumeUsd24Hr.text = "Volume Usd 24Hr: \(coinDetail.volumeUsd24Hr ?? "-")"
        labelCoinMarketCapUsd.text = "Market Cup Usd: \(coinDetail.marketCapUsd ?? "-")"
    }
    
   
    
}
