//
//  MyOrderViewController.swift
//  ALWekala
//
//  Created by Mac on 10/25/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class MyOrderViewController: UIViewController {
    @IBOutlet weak var orderTableView: UITableView!
    
    var orderList :[Myorder] = []
    let lang = UserDefaults.standard.value(forKey: "lang") as! String
    var parentView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(myOrder(_:)), name: NSNotification.Name(rawValue: "MyOrder"), object: nil)
        orderTableView.delegate = self
        orderTableView.dataSource = self
         self.orderTableView.separatorStyle = .none
       
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     @objc func myOrder(_ notification: NSNotification){
         let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
            orderTableView.semanticContentAttribute = .forceRightToLeft
        }else{
            orderTableView.semanticContentAttribute = .forceLeftToRight
        }
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            getData()
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func convertDateFormate(input:String,form:String)-> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: input)
        inputFormatter.dateFormat = form
        let resultString = inputFormatter.string(from: showDate!)
        print(resultString)
        return resultString
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getData(){
        orderList  = []
        let url = Constant.baseUrl + Constant.myOrder
        print(url)
           let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        //customer_id
        print("lang\(lang)")
        var parameter :[String:AnyObject] = [String:AnyObject]()
        if let data = UserDefaults.standard.data(forKey: "person"){
            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
            parameter["customer_id"] =  (person?.id)! as AnyObject?
            
        }
        parameter["language"] = lang as AnyObject?
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [[String:Any]]{
                        for item in datares {
                            let myorder = Myorder()
                             if let id = item["id"] as? Int {
                                myorder.id = id
                          }
                            if let status = item["status"] as? String {
                                myorder.status = status
                            }
                            if let type = item["type"]  as? String {
                                myorder.type = type
                            }
                            if let reasone = item["reasone"] as? String {
                                myorder.reasone = reasone
                            }
                            if let address = item["address"] as? String {
                                myorder.address = address
                            }
                            if let regoin = item["regoin"] as? String {
                                myorder.regoin = regoin
                            }
                            if let delevery_fees = item["delevery_fees"] as? Double {
                                myorder.delevery_fees = delevery_fees
                            }
                            if let total = item["total"] as? Double {
                                myorder.total = total
                            }
                            if let langitude = item["langitude"] as? String {
                                myorder.langitude = Double(langitude)
                            }
                            if let latitude = item["latitude"] as? String {
                                myorder.langitude = Double(latitude)
                            }
                            if let created_at = item["created_at"] as? String {
                                myorder.created_at = created_at
                            }
                            if let updated_at = item["updated_at"]  as? String{
                                myorder.updated_at = updated_at
                            }
                            if let items = item["items"] as? [Dictionary<String,Any>] {
                                for element in items {
                                    var veg  = Food()
                                    if let category = element["category"] as? String {
                                        veg.category = category
                                    }
                                    if let id = element["id"] as? Int {
                                        veg.id = id
                                    }
                                   
                                    if let quantity = element["quantatiy"] as? Int {
                                        veg.quantity = quantity
                                    }else{
                                        veg.quantity = 0 
                                    }
                                    if let marketPrice = element["market_price"] as? Double {
                                        veg.marketPrice = marketPrice
                                    }
                                    if let wekal_price = element["wekal_price"] as? Double {
                                        veg.wekalaPrice = wekal_price
                                    }
                                    if lang == "ar" {
                                        if let unit = element["unit_ar"] as? String{
                                            veg.unit = unit
                                        }
                                        if let name = element["name_ar"] as? String{
                                            veg.name = name
                                        }
                                    }else{
                                        if let unit = element["unit_en"] as? String{
                                            veg.unit = unit
                                        }
                                        if let name = element["name_en"] as? String{
                                            veg.name = name
                                        }
                                    }
                                   
                                    if let packingFees = element["packing_fees"] as? String{
                                        veg.packingFees = packingFees
                                    }
                                    if let image = element["image"] as? String {
                                        veg.image = image
                                    }
                                    myorder.item.append(veg)
                                    
                                }
                            }
                            self.orderList.append(myorder)
                        }
                       self.orderTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
}
extension MyOrderViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderDetailViewController") as! MyOrderDetailViewController
//        popupVC.item = orderList[indexPath.row]
//        self.addChildViewController(popupVC)
//        popupVC.view.frame = (parentView?.frame)!
//      //  popupVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        self.view.addSubview(popupVC.view)
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderDetailViewController") as! MyOrderDetailViewController
        customAlert.item = orderList[indexPath.row]
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        self.present(customAlert, animated: true, completion: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier:"MyOrderDetailViewController") as! MyOrderDetailViewController
//        vc.item = orderList[indexPath.row]
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyorderTableViewCell", for: indexPath) as! MyorderTableViewCell
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
         if lang == "ar" {
            cell.containerView .semanticContentAttribute = .forceRightToLeft
            cell.orderId.text = "orderId".localized(lang: "ar")
            cell.timeLBl.text = "time".localized(lang: "ar") + ":"
            cell.dateLbl.text = "date".localized(lang: "ar") + ":"
            cell.totalLbl.text = "total".localized(lang: "ar") + ":"
            cell.time.textAlignment = .right
            cell.date.textAlignment = .right
            cell.total.textAlignment = .right
            
         }else{
            cell.containerView .semanticContentAttribute = .forceLeftToRight
            cell.orderId.text = "Order Id:"
            cell.timeLBl.text = "Time:"
            cell.dateLbl.text = "Date:"
             cell.totalLbl.text = "Total:"
            cell.time.textAlignment = .left
            cell.date.textAlignment = .left
            cell.total.textAlignment = .left
        }
        cell.orderNumber.text = "\(orderList[indexPath.row].id!)"
        cell.total.text =  "\(orderList[indexPath.row].total!)"
        cell.date.text =  convertDateFormate(input: orderList[indexPath.row].created_at!, form: "dd-MM-yyyy")
        cell.time.text = convertDateFormate(input:orderList[indexPath.row].created_at!,form: "hh:mm a")
        var status = ""
         if lang == "ar" {
        if orderList[indexPath.row].status! ==  "0"{
            status = "pending".localized(lang: "ar")
        }else if orderList[indexPath.row].status! ==  "1" {
            status = "sent".localized(lang: "ar")
        }else  if orderList[indexPath.row].status! ==  "2" {
            status = "delivered".localized(lang: "ar")
        }else{
            status = "cancelled".localized(lang: "ar")
        }
         }else{
            if orderList[indexPath.row].status! ==  "0"{
                status = "Pending"
            }else if orderList[indexPath.row].status! ==  "1" {
                status = "sent"
            }else  if orderList[indexPath.row].status! ==  "2" {
                status = "deliverd"
            }else{
                status = "cancelled"
            }
        }
        if lang == "ar" {
            cell.status.text = "status".localized(lang: "ar") + ":" + status
        }else{
            cell.status.text = "Status:" + status
        }
        cell.containerView.layer.borderWidth = 0.5
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
      return 200
    }
    
}
