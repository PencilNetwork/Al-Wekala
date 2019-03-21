//
//  MyOrderDetailViewController.swift
//  ALWekala
//
//  Created by Mac on 10/28/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class MyOrderDetailViewController: UIViewController {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var deliveryFeesPrice: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var dayDelivery: UILabel!
    @IBOutlet weak var packingFeesPrice: UILabel!
    @IBOutlet weak var packingfees: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var totalLBL: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var item:Myorder?
      let lang = UserDefaults.standard.value(forKey: "lang") as! String
    var totalPack = 0.0
    var  stotalprice = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
          self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.foodTableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        containerView.layer.borderWidth = 0.5
        foodTableView.dataSource = self
        foodTableView.delegate = self
          self.foodTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
//        tableHeight.constant = foodTableView.contentSize.height
//        containerHeight.constant =  tableHeight.constant + 250
//        if (containerHeight.constant + 71) > viewHeight.constant {
//            viewHeight.constant  = containerHeight.constant + 71
//        }
     
        if lang == "ar" {
            itemLbl.text = "item".localized(lang: "ar")
           // itemLbl.textAlignment = .right
            quantityLbl.text = "quantity".localized(lang: "ar")
           // quantityLbl.textAlignment = .right
            totalLBL.text = "total".localized(lang: "ar")
            priceLBL.text = "price".localized(lang: "ar")
            packingfees.text = "packagingFees".localized(lang: "ar")
            deliveryFees.text = "deliveryFees".localized(lang: "ar")
            subTotal.text = "subtotal".localized(lang: "ar")
            containerView.semanticContentAttribute = .forceRightToLeft
            foodTableView.semanticContentAttribute = .forceRightToLeft
            dayDelivery.textAlignment = .right
        
        }else{
            containerView.semanticContentAttribute = .forceLeftToRight
            foodTableView.semanticContentAttribute = .forceLeftToRight
        }
        
        if item?.type == "1" { //day
            
            if lang == "ar" {
                dayDelivery.text = "dayDelivery".localized(lang: "ar")
                timeLbl.text =  "mornTime".localized(lang: "ar")
                timeLbl.textAlignment = .right
            }else{
                dayDelivery.text = "Day Delivery"
                   timeLbl.text =  "timeMorning".localized(lang: "en")
                timeLbl.textAlignment = .left
            }
            weatherImg.image = UIImage(named: "if_weather-01_1530392.png")
        }else{
            if lang == "ar" {
                dayDelivery.text = "nightDelivery".localized(lang: "ar")
                 timeLbl.text =  "nighTime".localized(lang: "ar")
                timeLbl.textAlignment = .right
            }else{
                dayDelivery.text = "Night Delivery"
                 timeLbl.text =  "timenight".localized(lang: "en")
                timeLbl.textAlignment = .left
            }
            weatherImg.image = UIImage(named: "if_weather-10_1530382.png")
        }
        var sum = 0.0
        
        for element in (item?.item)!{
            sum = sum + Double(element.quantity) * element.wekalaPrice!
            totalPack = totalPack + Double(element.quantity) * Double(element.packingFees!)!
        }
        totalPrice.text = "\(sum) L.E"
        packingFeesPrice.text = "\(totalPack) L.E"
        deliveryFeesPrice.text = "\((item?.delevery_fees)!)"
        stotalprice = sum + totalPack + (item?.delevery_fees)!  // total price
        subTotalPrice.text = "\(stotalprice) L.E"
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        foodTableView.layer.removeAllAnimations()
        tableHeight.constant = foodTableView.contentSize.height
        containerHeight.constant =  tableHeight.constant + 250
        if (containerHeight.constant + 71) > viewHeight.constant {
            viewHeight.constant  = containerHeight.constant + 71
        }
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.loadViewIfNeeded()
        }
        
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:IBAction
   
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
}
extension MyOrderDetailViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (item?.item.count)! > 0 {
            return (item?.item.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as! BillTableViewCell
        cell.itemName.text = item?.item[indexPath.row].name
        cell.quantityLbl.text = "\((item?.item[indexPath.row].quantity)!) \((item?.item[indexPath.row].unit)!)"
        cell.priceLbl.text = "\((item?.item[indexPath.row].wekalaPrice)!)"
        let total = Double((item?.item[indexPath.row].quantity)!) * (item?.item[indexPath.row].wekalaPrice)!
        cell.totalLBL.text = "\(total)"
        if lang == "ar" {
            cell.contentView.semanticContentAttribute = .forceRightToLeft
        }else{
            cell.contentView.semanticContentAttribute = .forceLeftToRight
       
        }
        return cell
    }
    
    
}
