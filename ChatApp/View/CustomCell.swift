//
//  CustomCell.swift
//  ChatApp
//
//  Created by 及田　一樹 on 2020/05/19.
//  Copyright © 2020 oita kazuki. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {


    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messasgeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
