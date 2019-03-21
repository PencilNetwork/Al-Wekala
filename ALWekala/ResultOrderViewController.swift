//
//  ResultOrderViewController.swift
//  ALWekala
//
//  Created by Mac on 10/25/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class ResultOrderViewController: UIViewController {

    @IBOutlet weak var succefullyCreatedLBL: UILabel!
    @IBOutlet weak var backToHomeBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var orderDetail: UILabel!
    
    
    @IBOutlet weak var orderIdLBL: UILabel!
    
    @IBOutlet weak var itWillBedeliveredLBL: UILabel!
     let lang = UserDefaults.standard.value(forKey: "lang") as! String
    var orderId :Int?
    var timeString :String?
      var cartData :CartData?
    override func viewDidLoad() {
        super.viewDidLoad()
        backToHomeBtn.layer.cornerRadius = 25
           if lang == "ar" {
            orderDetail.text = "تفاصيل الطلب"
            orderDetail.textAlignment = .right
            succefullyCreatedLBL.text = "orderIsCreated".localized(lang: "ar")
           orderIdLBL.text = "yourOrder".localized(lang: "ar")  + "\(orderId!)"
            itWillBedeliveredLBL.text = "itWillDelivered".localized(lang: "ar") + " " +  (cartData?.time!)!
            backToHomeBtn.setTitle("backToHome".localized(lang: "ar"), for: .normal)
           }else{
            orderDetail.textAlignment = .left
            orderIdLBL.text = "your Order ID is :" + "\(orderId!)"
              itWillBedeliveredLBL.text = "it will be delivered" + " " +  (cartData?.time!)!
           }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func backtoHomeBtnAction(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is MakeOrderViewController {
                            let a = aViewController as! MakeOrderViewController
                            a.refresh = true 
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        }
                    }
    }
    
}
