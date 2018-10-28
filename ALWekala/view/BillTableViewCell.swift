//
//  BillTableViewCell.swift
//  ALWekala
//
//  Created by Mac on 10/24/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    @IBOutlet weak var totalLBL: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
