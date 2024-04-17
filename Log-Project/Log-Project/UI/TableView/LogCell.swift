//
//  LogCell.swift
//  Log-Project
//
//  Created by Uğur Polat on 17.04.2024.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var labelLogLevel: UILabel!
    @IBOutlet weak var labelLogTime: UILabel!
    var log = Log()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
