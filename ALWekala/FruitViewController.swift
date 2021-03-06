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
    var parentView:MakeOrderViewController?
        private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
//        fruitCollectionView.layer.cornerRadius = 10
//        fruitCollectionView.layer.borderWidth = 2
//        fruitCollectionView.layer.borderColor = UIColor(red:201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        if #available(iOS 10.0, *) {
            self.fruitCollectionView.refreshControl = refreshControl
        } else {
            self.fruitCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshControlData(_:)), for: .valueChanged)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        fruitCollectionView.delegate = self
        fruitCollectionView.dataSource = self
       // fruitCollectionView.semanticContentAttribute = .forceLeftToRight
         let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
          //  fruitCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
           //fruitCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
           
        }else{
            
        }
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
       // getData()
            
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
       // NotificationCenter.default.addObserver(self, selector: #selector(updateLang(_:)), name: NSNotification.Name(rawValue: "refreshLang"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendfruites(_:)), name: NSNotification.Name(rawValue: "sendfruites"), object: nil)
        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Function
    @objc private func refreshControlData(_ sender: Any) {
        // Fetch Weather Data
      sendCardDelegate?.refreshControlData()
          self.refreshControl.endRefreshing()
    }
    @objc func sendfruites(_ notification: NSNotification){
        fruitList = []
        for item in (parentView?.fruitList)!  {
            print(item.name)
            fruitList.append(item)
        }
        self.fetchFromDatabase()
    }

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
                fruitCollectionView.reloadData()
            }
            
          //  self.fetchFromDatabase()
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
         if lang == "ar" {
          //   UIView.appearance().semanticContentAttribute = .forceRightToLeft
         }else{
           // UIView.appearance().semanticContentAttribute = .forceLeftToRight
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
        if fruitList[index].quantity == 1{
             fruitList[index].added = true
              sendCardDelegate?.sendItemToCart(Item: fruitList[index], flag: true)// add to cart and database
        }else{ //> 1  update cart
            sendCardDelegate?.updateItemInCart(ItemId:  fruitList[index].id!, Quantity: fruitList[index].quantity)
        }
        fruitCollectionView.reloadData()
    }
    
    func minItem(index:Int){
        if fruitList[index].quantity > 0{
        fruitList[index].quantity = fruitList[index].quantity - 1
            if fruitList[index].quantity == 0 {
                 fruitList[index].added = false
                   sendCardDelegate?.sendItemToCart(Item: fruitList[index], flag: false) //remove from cart and database
            }else{ //> o update cart
                sendCardDelegate?.updateItemInCart(ItemId:  fruitList[index].id!, Quantity: fruitList[index].quantity)
            }
        fruitCollectionView.reloadData()
        }
    }
    func addToCart(index:Int,added:Bool){
        if fruitList[index].quantity > 0{
            fruitList[index].added = added
            if fruitList[index].added == false{ // remove
                fruitList[index].quantity = 0 
            }
            fruitCollectionView.reloadData()
            sendCardDelegate?.sendItemToCart(Item: fruitList[index], flag: added)
        }
       
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
       // cell.contentView.isUserInteractionEnabled = true
       cell.alwekalaLBL.numberOfLines = 1
        cell.alwekalaLBL.adjustsFontSizeToFitWidth = true
        cell.alwekalaLBL.lineBreakMode = NSLineBreakMode.byClipping
        cell.imgWidth.constant = (self.view.frame.width - 10)/4
        cell.imgHeight.constant =  (self.view.frame.width - 10)/4
        cell.marketPriceTxtWidth.constant = ((self.view.frame.width - 10)/4) - 5
       
          cell.index = indexPath.row
          cell.added = fruitList[indexPath.row].added
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
             cell.marketPriceTxt.text = "market".localized(lang: "ar")
           cell.containerView.semanticContentAttribute = .forceRightToLeft
          
            let newStringStrike =   "\(fruitList[indexPath.row].marketPrice!)"
            let attributeString = NSMutableAttributedString(string: newStringStrike)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
           
            cell.marketPriceLBL.attributedText = attributeString
           // cell.marketPriceLBL.text = "marketPrice".localized(lang: "ar") + ":" + "\(fruitList[indexPath.row].marketPrice!)"
            cell.alwekalaLBL.text = "wekala".localized(lang: "ar")
            cell.wekalaPriceTxt.text =  "\(fruitList[indexPath.row].wekalaPrice!)"
            
        }else{
            cell.containerView.semanticContentAttribute = .forceLeftToRight
//            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            cell.wekalaPriceTxt.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.marketPriceTxt.text = "market".localized(lang: "en")
            let newStringStrike =   "\(fruitList[indexPath.row].marketPrice!)"
            let attributeString = NSMutableAttributedString(string: newStringStrike)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.marketPriceLBL.attributedText = attributeString
            cell.alwekalaLBL.text = "wekala".localized(lang: "en")
            cell.wekalaPriceTxt.text =   "\(fruitList[indexPath.row].wekalaPrice!)" 
           
           
        }
        if fruitList[indexPath.row].added == true {
            cell.photo.alpha = CGFloat(0.4)
           
        }else{
            cell.photo.alpha = 1
     
        }
        cell.itemDelegate = self
        cell.nameLBL.text = fruitList[indexPath.row].name
        cell.termLbl.text = fruitList[indexPath.row].unit
        cell.photo.sd_setImage(with: URL(string:fruitList[indexPath.row].image!), placeholderImage: UIImage(named: "wekalaLogo.png"))
        cell.quantity.text = "\(fruitList[indexPath.row].quantity)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return  CGSize(width: (view.frame.width - 4), height: (self.view.frame.width - 10)/3 + 30)
    }
    
}
