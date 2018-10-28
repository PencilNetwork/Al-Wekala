//
//  VegetableViewController.swift
//  ALWekala
//
//  Created by Mac on 10/22/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class VegetableViewController: UIViewController,ItemDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vegCollectionView: UICollectionView!
    var vegetableList:[Food] = []
     var sendCardDelegate:SendCardDelegate?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        vegCollectionView.delegate = self
        vegCollectionView.dataSource = self
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
//        if lang == "ar"{
//            vegCollectionView.semanticContentAttribute = .forceRightToLeft
//        }
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            getData()
            
        }else{
            if lang == "ar" {
                let alert = UIAlertController(title: "تحذير", message: "لا توجد شبكة", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
         NotificationCenter.default.addObserver(self, selector: #selector(refreshZeroItem(_:)), name: NSNotification.Name(rawValue: "zeroItemFruit"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(updateCart(_:)), name: NSNotification.Name(rawValue: "updatecart"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(deleteFromcart(_:)), name: NSNotification.Name(rawValue: "deleteCart"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(updateLang(_:)), name: NSNotification.Name(rawValue: "refreshLang"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func refreshZeroItem(_ notification: NSNotification){
        for item in vegetableList{
            item.quantity = 0
            item.added = false
        }
        vegCollectionView.reloadData()
    }
    func fetchFromDatabase(){
        var  foodData:[Food] = []
        var context  : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            context = appdelegate.persistentContainer.viewContext
        }else{
            context =  Storage.shared.context
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CartFood")
        request.returnsObjectsAsFaults = false // to return data as way as you saved it
        let data = UserDefaults.standard.data(forKey: "person")
        let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
        let predicate2 = NSPredicate(format: "customerId == '\((person?.id)!)'")
        
        request.predicate = predicate2
        do {
            let results = try context?.fetch(request)
            if (results?.count)! > 0 {
                for result in results as! [NSManagedObject]{
                    var food = Food()
                    if let id = result.value(forKey: "id") as? Int {
                        food.id = id
                    }
                    if let quantity = result.value(forKey: "quantity") as? Int {
                        food.quantity = quantity
                    }
                   
                    foodData.append(food)
                    
                }
                
            }
        }catch{
            print("error to retrieve")
        }
        
        for item in foodData{
            for term in vegetableList {
                if term.id == item.id {
                    term.quantity = item.quantity
                    term.added = true
                    
                }
            }
        }
        vegCollectionView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:Function
    @objc func updateLang(_ notification: NSNotification){
        vegetableList = []
         let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            getData()
            
        }else{
            if lang == "ar" {
                let alert = UIAlertController(title: "تحذير", message: "لا توجد شبكة", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
      @objc func updateCart(_ notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            
            if let id = dict["id"] as? Int {
                for i in 0..<vegetableList.count{
                    if vegetableList[i].id == id {
                        if let quantity = dict["quantity"] as? Int{
                            vegetableList[i].quantity = quantity
                            vegCollectionView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
    @objc func deleteFromcart(_ notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            
            if let id = dict["id"] as? Int {
                for i in 0..<vegetableList.count{
                    if vegetableList[i].id == id {
                        vegetableList[i].added = false
                        vegetableList[i].quantity = 0
                        vegCollectionView.reloadData()
                    }
                }
            }
            
        }
    }
    func plusItem(index:Int){
        vegetableList[index].quantity = vegetableList[index].quantity + 1
        vegCollectionView.reloadData()
    }
    
    func minItem(index:Int){
        vegetableList[index].quantity = vegetableList[index].quantity - 1
        vegCollectionView.reloadData()
    }
    func addToCart(index:Int,added:Bool){
        vegetableList[index].added = added
        vegCollectionView.reloadData()
        sendCardDelegate?.sendItemToCart(Item: vegetableList[index], flag: added)
    }
    func getData(){
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["language"] = lang   as AnyObject?
        let url = Constant.baseUrl + Constant.getItem
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let vegetable = datares["vegtables"] as? [Dictionary<String,Any>]{
                            for item in vegetable {
                                var vegItem = Food()
                                if let id = item["id"] as? Int {
                                    vegItem.id = id
                                }
                                if let name = item["name"] as? String{
                                    vegItem.name = name
                                }
                                if let marketPrice = item["market_price"] as? Double {
                                    vegItem.marketPrice = marketPrice
                                }
                                if let wekal_price = item["wekal_price"] as? Double {
                                    vegItem.wekalaPrice = wekal_price
                                }
                                if let unit = item["unit"] as? String{
                                    vegItem.unit = unit
                                }
                                if let packingFees = item["packing_fees"] as? String{
                                    vegItem.packingFees = packingFees
                                }
                                if let category = item["category"] as? String{
                                    vegItem.category = category
                                }
                                if let image = item["image"] as? String {
                                    vegItem.image = image
                                }
                                self.vegetableList.append(vegItem)
                                
                            }
                           
                        }
                      //  self.sendCardDelegate?.sendFood(food:self.vegetableList)
                        //   self.vegCollectionView.reloadData()
                        self.fetchFromDatabase()
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
extension VegetableViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if vegetableList.count > 0{
            return vegetableList.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VegetableCollectionViewCell", for: indexPath) as! VegetableCollectionViewCell
        cell.index = indexPath.row
        cell.added = vegetableList[indexPath.row].added
        if vegetableList[indexPath.row].added == true {
            cell.photo.alpha = CGFloat(0.4)
            cell.addToCard.backgroundColor = UIColor.red
            cell.addToCard.setTitle("Added", for: .normal)
            cell.minusBtn.isEnabled = false
            cell.plusBtn.isEnabled = false
            cell.marketPrice.alpha = CGFloat(0.4)
            cell.marketPriceLBL.alpha = CGFloat(0.4)
            cell.wekalaPriceLBL.alpha = CGFloat(0.4)
            cell.wekalaPriceTxt.alpha = CGFloat(0.4)
            cell.nameLBL.alpha = CGFloat(0.4)
            cell.termLbl.alpha = CGFloat(0.4)
            cell.quantity.alpha = CGFloat(0.4)
        }else{
            cell.photo.alpha = 1
            cell.marketPrice.alpha = 1
            cell.marketPriceLBL.alpha = 1
            cell.wekalaPriceLBL.alpha = 1
            cell.wekalaPriceTxt.alpha = 1
            cell.termLbl.alpha = 1
            cell.quantity.alpha = 1
            cell.nameLBL.alpha = 1
            cell.addToCard.backgroundColor = UIColor.black
            cell.addToCard.setTitle("Add to cart", for: .normal)
            cell.minusBtn.isEnabled = true
            cell.plusBtn.isEnabled = true
        }
        cell.itemDelegate = self
         cell.added = vegetableList[indexPath.row].added
        cell.marketPriceLBL.text = "\(vegetableList[indexPath.row].marketPrice!)"
        cell.wekalaPriceTxt.text = "\(vegetableList[indexPath.row].wekalaPrice!)"
        cell.nameLBL.text = vegetableList[indexPath.row].name
        cell.termLbl.text = vegetableList[indexPath.row].unit
        cell.photo.sd_setImage(with: URL(string:vegetableList[indexPath.row].image!), placeholderImage: UIImage(named: "Generic_Tomatoes.png"))
        cell.quantity.text = "\(vegetableList[indexPath.row].quantity)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (view.frame.width - 10), height: 263)
    }
    
}
