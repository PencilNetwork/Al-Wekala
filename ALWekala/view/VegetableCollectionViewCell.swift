//
//  VegetableCollectionViewCell.swift
//  ALWekala
//
//  Created by Mac on 10/22/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class VegetableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addToCard: UIButton!
    @IBOutlet weak var marketPriceLBL: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var wekalaPriceTxt: UILabel!
    @IBOutlet weak var wekalaPriceLBL: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var termLbl: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var photo: UIImageView!
    var index:Int?
    var itemDelegate:ItemDelegate?
    var added:Bool?
    @IBAction func minusBtnAction(_ sender: Any) {
        itemDelegate?.minItem(index: index!)
    }
    
    @IBAction func plusBtnAction(_ sender: Any) {
        itemDelegate?.plusItem(index: index!)
    }
    
    @IBAction func addToCartBtn(_ sender: Any) {
        added = !added!
        
        itemDelegate?.addToCart(index: index!,added:added!)
        
    }
}
