//
//  ConfirmedOrderViewController.swift
//  ALWekala
//
//  Created by Mac on 10/24/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class ConfirmedOrderViewController: UIViewController {
    @IBOutlet weak var subTotal: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    @IBOutlet weak var confirmedOrderBtn: UIButton!
    
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var cartData :CartData?
    let lang = UserDefaults.standard.value(forKey: "lang") as! String
     var totalPack = 0.0
    var  stotalprice = 0.0
    var totalWithOutDeliveryOrPack = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        self.navigationController?.isNavigationBarHidden = false
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.foodTableView.separatorStyle = .none
        confirmedOrderBtn.layer.cornerRadius = 10
        foodTableView.dataSource = self
        foodTableView.delegate = self
        tableHeight.constant = CGFloat((cartData?.cartList.count)! * 60)
        containerHeight.constant =  tableHeight.constant + 250
        if (containerHeight.constant + 104) > viewHeight.constant {
            viewHeight.constant  = containerHeight.constant + 104
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
            confirmedOrderBtn.setTitle("confirmOrder".localized(lang: "ar"), for: .normal)
            containerView.semanticContentAttribute = .forceRightToLeft
            foodTableView.semanticContentAttribute = .forceRightToLeft
            dayDelivery.textAlignment = .right 
        }
        
        if cartData?.day! == 1 { //day
           
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
        
        for item in (cartData?.cartList)!{
            sum = sum + Double(item.quantity) * item.wekalaPrice!
            totalPack = totalPack + Double(item.quantity) * Double(item.packingFees!)!
        }
        totalPrice.text = "\(sum) L.E"
        totalWithOutDeliveryOrPack = sum
         packingFeesPrice.text = "\(totalPack) L.E"
        deliveryFeesPrice.text = "\((cartData?.deliveryfees)!) " + "L.E"
         stotalprice = sum + totalPack + (cartData?.deliveryfees)!  // total price
        subTotalPrice.text = "\(stotalprice) L.E"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func deleteFromDatabase(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        var context  : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            context = appdelegate.persistentContainer.viewContext
        }else{
            context =  Storage.shared.context
        }
        let fetchRequest:NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName:"CartFood")
        let data = UserDefaults.standard.data(forKey: "person")
        let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
        let predicate2 = NSPredicate(format: "customerId == '\((person?.id)!)'")
        
        fetchRequest.predicate = predicate2
        //  fetchRequest.predicate=NSPredicate(format: "name = %@", "song1")
        
        do{
            var  fetchedItems = try context?.fetch(fetchRequest)
            for item in fetchedItems!{
                context?.delete(item as! NSManagedObject)
            }
        }catch{
            fatalError("Could not fetch")
        }
        
        
        do {
            try  context?.save()
            print("delete")
         
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = ""
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    func sendData(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var parameter :[String:AnyObject] = [String:AnyObject]()
        var cardItems :[[String:AnyObject]] = []
        for item in (cartData?.cartList)!{
            var cart :[String:AnyObject] = [String:AnyObject]()
            cart["id"] = item.id! as  AnyObject?
            cart["quantatiy"] =  item.quantity as  AnyObject?
            cart["total_per_quantatiy"] = Double(item.quantity) * (item.wekalaPrice)! as  AnyObject?
            cardItems.append(cart)
        }
        parameter["sub_total"] = totalWithOutDeliveryOrPack  as AnyObject?
        parameter["items"] = cardItems as AnyObject?
        parameter["delevery_fees"] = (cartData?.deliveryfees)! as AnyObject?
        parameter["total_packing_fees"] = totalPack as AnyObject?
        parameter["total"] = stotalprice as AnyObject?
        parameter["type"] = (cartData?.day)! as AnyObject?
        parameter["address"] = (cartData?.address)! as AnyObject?
        parameter["regoin"] = (cartData?.region)! as AnyObject?
        parameter["langitude"] = (cartData?.longitude)! as AnyObject?
        parameter["latitude"] = (cartData?.latitude)! as AnyObject?
        parameter["flat_number"] = (cartData?.flatNumber)! as AnyObject?
        parameter["city"] = "alex" as AnyObject?
        parameter["besides"] = (cartData?.beside)! as AnyObject?
        if let data = UserDefaults.standard.data(forKey: "person"){
            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
            parameter["customer_id"] =  (person?.id)! as AnyObject?
            parameter["phone"] =  (person?.phone)! as AnyObject?
        }
        parameter["total"] = stotalprice as AnyObject?
        let url = Constant.baseUrl + Constant.createOrder
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let order_id = datares["order_id"] as? Int {
                             self.deleteFromDatabase()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultOrderViewController") as! ResultOrderViewController
                            vc.orderId = order_id
                            vc.cartData = self.cartData
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        if let flag = datares["flag"] as? String {
                            if flag == "0" {
                                self.showToast(message: "fail to make order")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
   //
      //  parameter["name"] = nameTxt.text! as AnyObject?
    }

    @IBAction func confirmedOrderBtnAction(_ sender: Any) {
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            sendData()
            
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
extension ConfirmedOrderViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cartData?.cartList.count)! > 0 {
            return (cartData?.cartList.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableViewCell", for: indexPath) as! BillTableViewCell
         cell.itemName.text = cartData?.cartList[indexPath.row].name
        cell.quantityLbl.text = "\((cartData?.cartList[indexPath.row].quantity)!) \((cartData?.cartList[indexPath.row].unit)!)"
        cell.priceLbl.text = "\((cartData?.cartList[indexPath.row].wekalaPrice)!)"
        let total = Double((cartData?.cartList[indexPath.row].quantity)!) * (cartData?.cartList[indexPath.row].wekalaPrice)!
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
