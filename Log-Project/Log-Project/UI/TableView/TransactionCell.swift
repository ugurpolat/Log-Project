//
//  TransactionCell.swift
//  Log-Project
//
//  Created by Uğur Polat on 24.04.2024.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionIcon: UIImageView!
    @IBOutlet weak var TransactionTime: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: Transaction) {
        transactionName.text = viewModel.name
        transactionIcon.image = UIImage(named: viewModel.id)
        TransactionTime.text = viewModel.time
        transactionAmount.text = String(viewModel.amount)
        transactionPrice.text = String(viewModel.price)
    }
}
