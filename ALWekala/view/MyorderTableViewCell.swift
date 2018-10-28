//
//  MyorderTableViewCell.swift
//  ALWekala
//
//  Created by jackleen emil on 10/27/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class MyorderTableViewCell: UITableViewCell {
 @IBOutlet weak var orderNumber: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeLBl: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
