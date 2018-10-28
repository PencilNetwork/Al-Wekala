//
//  CartTableViewCell.swift
//  ALWekala
//
//  Created by Mac on 10/23/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var unit: UILabel!
    var index:Int?
    var cartAction:CartAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func minusBtnAction(_ sender: Any) {
           cartAction?.minusToCart(index: index!)
        
    }
    
    @IBAction func plusBtnAction(_ sender: Any) {
           cartAction?.plusToCart(index: index!)
    }
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        cartAction?.deleteFromCart(index: index!)
    }
    
}
