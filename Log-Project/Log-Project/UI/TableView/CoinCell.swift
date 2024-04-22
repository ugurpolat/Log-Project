//
//  CoinCellTableViewCell.swift
//  Log-Project
//
//  Created by Uğur Polat on 26.03.2024.
//

import UIKit

class CoinCell: UITableViewCell {
    
    @IBOutlet weak var labelCoinName: UILabel!
    @IBOutlet weak var labelCoinSymbol: UILabel!
    var coin = Coin()
    
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
        
    }
    
}
