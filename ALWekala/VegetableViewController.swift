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
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // cell.contentView.isUserInteractionEnabled = true
        cell.index = indexPath.row
        cell.added = vegetableList[indexPath.row].added
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
            
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            cell.wekalaPriceLBL.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            
            cell.wekalaPriceTxt.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.wekalaPriceTxt.textAlignment = .left
            cell.marketPrice.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.marketPriceLBL.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.addToCard.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.termLbl.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.quantity.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.nameLBL.transform  = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            cell.marketPriceLBL.textAlignment = .left
            cell.nameLBL.textAlignment = .left
            
            cell.wekalaPriceLBL.text = "wekalaPrice".localized(lang: "en")
            cell.marketPrice.text = "marketPrice".localized(lang: "en")
        }
        if vegetableList[indexPath.row].added == true {
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
