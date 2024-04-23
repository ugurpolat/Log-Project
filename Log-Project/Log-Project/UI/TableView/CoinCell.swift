//
//  CoinCellTableViewCell.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import UIKit

protocol CoinCellProtocol {
    func clickedfavorite(indexPath:IndexPath)
}
class CoinCell: UITableViewCell {
    
    @IBOutlet weak var labelCoinName: UILabel!
    @IBOutlet weak var labelCoinSymbol: UILabel!
    @IBOutlet weak var buttonCoinFav: UIButton!
    
    var coin = Coin()
    var isStarFilled: Bool = false
    var cellProtocol:CoinCellProtocol?
    var indexPath:IndexPath?
    var coinId:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    func configure(with viewModel: Coin) {
        labelCoinName.text = viewModel.name
        labelCoinSymbol.text = viewModel.symbol
        coinId = viewModel.id!
        
        if let favId = viewModel.id {
            let favoriteCoins = UserDefaults.standard.array(forKey: "favoriteCoinList") as? [String] ?? []
            let imageName = favoriteCoins.contains(favId) ? "star.fill" : "star"
            buttonCoinFav.setImage(UIImage(systemName: imageName), for: .normal)
        } else {
            buttonCoinFav.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBAction func changeCellButtonColor(_ sender: UIButton) {
        if let indexPath = indexPath {
            cellProtocol?.clickedfavorite(indexPath: indexPath)
            updateButtonAppearance()
        }
    }
    
    func updateButtonAppearance() {
        guard let favId = coin.id else { return }
        let favoriteCoins = UserDefaults.standard.array(forKey: "favoriteCoinList") as? [String] ?? []
        let isFavorite = favoriteCoins.contains(favId)
        let imageName = isFavorite ? "star.fill" : "star"
        buttonCoinFav.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}
