//
//  MyOrderDetailViewController.swift
//  ALWekala
//
//  Created by Mac on 10/28/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class MyOrderDetailViewController: UIViewController {
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
            self.foodTableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        containerView.layer.borderWidth = 0.5
        foodTableView.dataSource = self
        foodTableView.delegate = self
        tableHeight.constant = CGFloat((item?.item.count)! * 60)
        containerHeight.constant =  tableHeight.constant + 250
        if (containerHeight.constant + 71) > viewHeight.constant {
            viewHeight.constant  = containerHeight.constant + 71
        }
        if lang == "ar" {
            itemLbl.text = "item".localized(lang: "ar")
            quantityLbl.text = "quantity".localized(lang: "ar")
            quantityLbl.textAlignment = .right
            totalLBL.text = "total".localized(lang: "ar")
            priceLBL.text = "price".localized(lang: "ar")
            packingfees.text = "packagingFees".localized(lang: "ar")
            deliveryFees.text = "deliveryFees".localized(lang: "ar")
            subTotal.text = "subtotal".localized(lang: "ar")
            containerView.semanticContentAttribute = .forceRightToLeft
            foodTableView.semanticContentAttribute = .forceRightToLeft
            dayDelivery.textAlignment = .right
        }
        
        if item?.type == "1" { //day
            
            if lang == "ar" {
                dayDelivery.text = "dayDelivery".localized(lang: "ar")
                
            }else{
                dayDelivery.text = "Day Delivery"
            }
            weatherImg.image = UIImage(named: "if_weather-01_1530392.png")
        }else{
            if lang == "ar" {
                dayDelivery.text = "nightDelivery".localized(lang: "ar")
            }else{
                dayDelivery.text = "Night Delivery"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
            cell.itemName.textAlignment = .right
            cell.quantityLbl.textAlignment = .right
            cell.priceLbl.textAlignment = .right
            cell.contentView.semanticContentAttribute = .forceRightToLeft
        }
        return cell
    }
    
    
}
