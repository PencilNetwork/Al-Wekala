//
//  FruitViewController.swift
//  ALWekala
//
//  Created by Mac on 10/22/18.
//  Copyright © 2018 pencil. All rights reserved.
//
protocol ItemDelegate{
    func plusItem(index:Int)
    func minItem(index:Int)
    func addToCart(index:Int,added:Bool)
}
import UIKit
import Alamofire
import CoreData
class FruitViewController: UIViewController ,ItemDelegate{
  
    @IBOutlet weak var fruitCollectionView: UICollectionView!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var sendCardDelegate:SendCardDelegate?
    var fruitList:[Food] = []
     let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        fruitCollectionView.delegate = self
        fruitCollectionView.dataSource = self
         let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
          //  fruitCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
           //fruitCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
//            containerView.semanticContentAttribute = .forceRightToLeft
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart(_:)), name: NSNotification.Name(rawValue: "updatecartfruites"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFromcart(_:)), name: NSNotification.Name(rawValue: "deleteCartfruites"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLang(_:)), name: NSNotification.Name(rawValue: "refreshLang"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(sendFruit(_:)), name: NSNotification.Name(rawValue: "sendFruit"), object: nil)
        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Function
    
      @objc func refreshZeroItem(_ notification: NSNotification){
        for item in fruitList{
            item.quantity = 0
            item.added = false
        }
        fruitCollectionView.reloadData()
    }
     @objc func sendFruit(_ notification: NSNotification){
        fruitList = []
         if let dict = notification.userInfo as NSDictionary? {
            if let fruit = dict["fruit"] as? [Dictionary<String,Any>]{
                for item in fruit {
                      var fruitItem = Food()
                    if let id = item["id"] as? Int {
                        fruitItem.id = id
                    }
                    if let name = item["name"] as? String{
                        fruitItem.name = name
                    }
                    if let marketPrice = item["market_price"] as? Double {
                        fruitItem.marketPrice = marketPrice
                    }
                    if let wekal_price = item["wekal_price"] as? Double {
                        fruitItem.wekalaPrice = wekal_price
                    }
                    if let unit = item["unit"] as? String{
                        fruitItem.unit = unit
                    }
                    if let packingFees = item["packing_fees"] as? String{
                        fruitItem.packingFees = packingFees
                    }
                    if let category = item["category"] as? String{
                        fruitItem.category = category
                    }
                    if let image = item["image"] as? String {
                        fruitItem.image = image
                    }
                    self.fruitList.append(fruitItem)
                }
                self.fetchFromDatabase()
            }
        }
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
//                    if let name = result.value(forKey: "name") as? String{
//                        food.name = name
//                    }
//                    if let wekalaPrice = result.value(forKey: "wekalaPrice") as? Double {
//                        food.wekalaPrice = wekalaPrice
//                    }
//                    if let unit = result.value(forKey: "unit") as? String{
//                        food.unit = unit
//                    }
//                    if let packingFees = result.value(forKey: "packingFees") as? String{
//                        food.packingFees = packingFees
//                    }
//                    if let marketPrice = result.value(forKey: "marketPrice") as? Double{
//                        food.marketPrice = marketPrice
//                    }
//                    if let image = result.value(forKey: "image") as? String{
//                        food.image = image
//                    }
//                    if let category = result.value(forKey: "category") as? String{
//                        food.category = category
//                    }
//                    if let added = result.value(forKey: "added") as? Bool{
//                        food.added = added
//                    }
                    foodData.append(food)
                    
                }
                
            }
        }catch{
            print("error to retrieve")
        }
        
        for item in foodData{
            for term in fruitList {
                if term.id == item.id {
                    term.quantity = item.quantity
                    term.added = true
                    
                }
            }
        }
        fruitCollectionView.reloadData()
    }
    
    @objc func updateLang(_ notification: NSNotification){
        fruitList = []
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
                for i in 0..<fruitList.count{
                    if fruitList[i].id == id {
                        if let quantity = dict["quantity"] as? Int{
                            fruitList[i].quantity = quantity
                            fruitCollectionView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
    @objc func deleteFromcart(_ notification: NSNotification){
        if let dict = notification.userInfo as NSDictionary? {
            
            if let id = dict["id"] as? Int {
                for i in 0..<fruitList.count{
                    if fruitList[i].id == id {
                        fruitList[i].added = false
                        fruitList[i].quantity = 0
                        fruitCollectionView.reloadData()
                    }
                }
            }
            
        }
    }
    func plusItem(index:Int){
        fruitList[index].quantity = fruitList[index].quantity + 1
        fruitCollectionView.reloadData()
    }
    
    func minItem(index:Int){
        fruitList[index].quantity = fruitList[index].quantity - 1
        fruitCollectionView.reloadData()
    }
    func addToCart(index:Int,added:Bool){
        fruitList[index].added = added
        fruitCollectionView.reloadData()
         sendCardDelegate?.sendItemToCart(Item: fruitList[index], flag: added)
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
                        if let fruit = datares["fruites"] as? [Dictionary<String,Any>]{
                            for item in fruit {
                            var fruitItem = Food()
                            if let id = item["id"] as? Int {
                                fruitItem.id = id
                            }
                            if let name = item["name"] as? String{
                                    fruitItem.name = name
                            }
                                if let marketPrice = item["market_price"] as? Double {
                                    fruitItem.marketPrice = marketPrice
                                }
                                if let wekal_price = item["wekal_price"] as? Double {
                                    fruitItem.wekalaPrice = wekal_price
                                }
                                if let unit = item["unit"] as? String{
                                    fruitItem.unit = unit
                                }
                                if let packingFees = item["packing_fees"] as? String{
                                    fruitItem.packingFees = packingFees
                                }
                                if let category = item["category"] as? String{
                                    fruitItem.category = category
                                }
                                if let image = item["image"] as? String {
                                    fruitItem.image = image 
                                }
                                self.fruitList.append(fruitItem)
                                
                          }
                           
                           // self.fruitCollectionView.reloadData()
                        }
                       // self.sendCardDelegate?.sendFood(food:self.fruitList)
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
extension FruitViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fruitList.count > 0{
            return fruitList.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VegetableCollectionViewCell", for: indexPath) as! VegetableCollectionViewCell
          cell.index = indexPath.row
          cell.added = fruitList[indexPath.row].added
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            cell.wekalaPriceLBL.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.wekalaPriceLBL.text = "wekalaPrice".localized(lang: "ar") + ":"
            
            cell.wekalaPriceTxt.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.wekalaPriceTxt.textAlignment = .right
            cell.marketPrice.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.marketPriceLBL.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.addToCard.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.termLbl.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.quantity.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.nameLBL.transform  = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.marketPrice.text = "marketPrice".localized(lang: "ar") + ":"
            cell.marketPriceLBL.textAlignment = .right
            cell.nameLBL.textAlignment = .right
        }else{
            cell.wekalaPriceLBL.text = "wekalaPrice".localized(lang: "en")
            cell.marketPrice.text = "marketPrice".localized(lang: "en")
        }
        if fruitList[indexPath.row].added == true {
            cell.photo.alpha = CGFloat(0.4)
            cell.addToCard.backgroundColor = UIColor.red
            if lang == "ar" {
                 cell.addToCard.setTitle("added".localized(lang: "ar"), for: .normal)
            }else{
                 cell.addToCard.setTitle("Added", for: .normal)
            }
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
            if lang == "ar" {
                cell.addToCard.setTitle("addtoCart".localized(lang: "ar"), for: .normal)
            }else{
               cell.addToCard.setTitle("Add to cart", for: .normal)
            }
            
            cell.minusBtn.isEnabled = true
            cell.plusBtn.isEnabled = true
        }
        cell.itemDelegate = self
         cell.marketPriceLBL.text = "\(fruitList[indexPath.row].marketPrice!)"
        cell.wekalaPriceTxt.text = "\(fruitList[indexPath.row].wekalaPrice!)"
        cell.nameLBL.text = fruitList[indexPath.row].name
        cell.termLbl.text = fruitList[indexPath.row].unit
        cell.photo.sd_setImage(with: URL(string:fruitList[indexPath.row].image!), placeholderImage: UIImage(named: "apple.png"))
        cell.quantity.text = "\(fruitList[indexPath.row].quantity)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (view.frame.width - 10), height: 263)
    }
    
}
