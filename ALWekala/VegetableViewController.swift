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

  
    @IBOutlet weak var vegCollectionView: UICollectionView!
    var vegetableList:[Food] = []
     var sendCardDelegate:SendCardDelegate?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
     var parentView:MakeOrderViewController?
      private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
//        vegCollectionView.layer.cornerRadius = 10
//        vegCollectionView.layer.borderWidth = 2
//        vegCollectionView.layer.borderColor = UIColor(red:201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        if #available(iOS 10.0, *) {
            self.vegCollectionView.refreshControl = refreshControl
        } else {
            self.vegCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshControlData(_:)), for: .valueChanged)
         UIView.appearance().semanticContentAttribute = .forceLeftToRight
        vegCollectionView.delegate = self
        vegCollectionView.dataSource = self
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
//        if lang == "ar"{
//            vegCollectionView.semanticContentAttribute = .forceRightToLeft
//        }
       
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(refreshZeroItem(_:)), name: NSNotification.Name(rawValue: "zeroItemFruit"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(updateCart(_:)), name: NSNotification.Name(rawValue: "updatecart"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(deleteFromcart(_:)), name: NSNotification.Name(rawValue: "deleteCart"), object: nil)
       //  NotificationCenter.default.addObserver(self, selector: #selector(updateLang(_:)), name: NSNotification.Name(rawValue: "refreshLang"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendfruites(_:)), name: NSNotification.Name(rawValue: "sendfruites"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc private func refreshControlData(_ sender: Any) {
        // Fetch Weather Data
        sendCardDelegate?.refreshControlData()
        self.refreshControl.endRefreshing()
    }
    @objc func sendfruites(_ notification: NSNotification){
        vegetableList = []
        for item in (parentView?.vegList)!  {
            print(item.name)
            vegetableList.append(item)
        }
        self.fetchFromDatabase()
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
        
        if vegetableList[index].quantity == 1{
             vegetableList[index].added = true
            sendCardDelegate?.sendItemToCart(Item: vegetableList[index], flag: true)// add to cart and database
        }else{ //> 1  update cart
            sendCardDelegate?.updateItemInCart(ItemId:  vegetableList[index].id!, Quantity: vegetableList[index].quantity)
        }
         vegCollectionView.reloadData()
    }
    
    func minItem(index:Int){
        if vegetableList[index].quantity > 0{
            vegetableList[index].quantity = vegetableList[index].quantity - 1
            if vegetableList[index].quantity == 0 {
                 vegetableList[index].added = false
                sendCardDelegate?.sendItemToCart(Item: vegetableList[index], flag: false) //remove from cart and database
            }else{ //> o update cart
                sendCardDelegate?.updateItemInCart(ItemId:  vegetableList[index].id!, Quantity: vegetableList[index].quantity)
            }
            vegCollectionView.reloadData()
        }
    }
    func addToCart(index:Int,added:Bool){
    if vegetableList[index].quantity > 0{
        vegetableList[index].added = added
        if vegetableList[index].added == false{ // remove
            vegetableList[index].quantity = 0
        }
        vegCollectionView.reloadData()
        sendCardDelegate?.sendItemToCart(Item: vegetableList[index], flag: added)
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
        cell.alwekalaLBL.numberOfLines = 1
        cell.alwekalaLBL.adjustsFontSizeToFitWidth = true
        cell.alwekalaLBL.lineBreakMode = NSLineBreakMode.byClipping
        // cell.contentView.isUserInteractionEnabled = true
       
//        if indexPath.row < vegetableList.count - 1 {
//            cell.lineView.isHidden = false
//        }else{
//             cell.lineView.isHidden = true
//        }
        cell.imgWidth.constant = (self.view.frame.width - 10)/4
        cell.imgHeight.constant =  (self.view.frame.width - 10)/4
        cell.marketPriceTxtWidth.constant = ((self.view.frame.width - 10)/4) - 5
        //cell.addtoCardWidth.constant = (self.view.frame.width - 5 )/4
        cell.index = indexPath.row
        cell.added = vegetableList[indexPath.row].added
//        cell.addToCard.titleLabel?.numberOfLines = 1
//        cell.addToCard.titleLabel?.adjustsFontSizeToFitWidth = true
//        cell.addToCard.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            cell.containerView.semanticContentAttribute = .forceRightToLeft
            cell.marketPriceTxt.text = "market".localized(lang: "ar")   
            let newStringStrike =   "\(vegetableList[indexPath.row].marketPrice!)"  
            let attributeString = NSMutableAttributedString(string: newStringStrike)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            
            cell.marketPriceLBL.attributedText = attributeString
           cell.alwekalaLBL.text = "wekala".localized(lang: "ar")
            cell.wekalaPriceTxt.text =   "\(vegetableList[indexPath.row].wekalaPrice!)"
        }else{
            cell.marketPriceTxt.text = "market".localized(lang: "en")
           
            let newStringStrike =   "\(vegetableList[indexPath.row].marketPrice!)"
            let attributeString = NSMutableAttributedString(string: newStringStrike)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
           
            cell.marketPriceLBL.attributedText = attributeString
      
            cell.containerView.semanticContentAttribute = .forceLeftToRight
         
            cell.alwekalaLBL.text = "wekala".localized(lang: "en")
            cell.wekalaPriceTxt.text =  "\(vegetableList[indexPath.row].wekalaPrice!)"
            
           
        }
        if vegetableList[indexPath.row].added == true {
            cell.photo.alpha = CGFloat(0.4)
           
        }else{
            cell.photo.alpha = 1

        }
        cell.itemDelegate = self
      
        cell.nameLBL.text = vegetableList[indexPath.row].name
        cell.termLbl.text = vegetableList[indexPath.row].unit
        cell.photo.sd_setImage(with: URL(string:vegetableList[indexPath.row].image!), placeholderImage: UIImage(named: "wekalaLogo.png"))
        cell.quantity.text = "\(vegetableList[indexPath.row].quantity)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return  CGSize(width: (view.frame.width - 4), height: (self.view.frame.width - 10)/3 + 30)
    }
    
}
