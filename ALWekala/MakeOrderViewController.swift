//
//  MakeOrderViewController.swift
//  ALWekala
//
//  Created by Mac on 10/22/18.
//  Copyright © 2018 pencil. All rights reserved.
//

protocol SendCardDelegate{
    func sendItemToCart(Item:Food,flag:Bool)
    func updateItemInCart(ItemId:Int,Quantity:Int)
    func refreshControlData()
 //   func sendFood(food:[Food])
}
protocol CartAction{
    func plusToCart(index:Int)
    func minusToCart(index:Int)
    func deleteFromCart(index:Int)
}
import UIKit
import CoreData
import Alamofire
class MakeOrderViewController: UIViewController ,SendCardDelegate,CartAction{
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var productLbL: UILabel!
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pageTitleLBL: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myProfileView: UIView!
    @IBOutlet weak var myOrderView: UIView!
    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var itemView: UIView!
    
    @IBOutlet weak var checkOutbtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nightTimeLbl: UILabel!
    @IBOutlet weak var dayTimeLbl: UILabel!
    @IBOutlet weak var nightDeliveryLbl: UILabel!
    @IBOutlet weak var dayDeliveryLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fruitView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var vegView: UIView!
    @IBOutlet weak var languageBtn: UIButton!
    
    @IBOutlet weak var MiddleView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var totalLbl: UILabel!
   var refresh = false 
    var cartList :[Food] = []
     let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var foodList:[Food] = []
    var foodDatabase:[Food] = []
    var menu_vc:UserMenuViewController!
    var tab = 0
    var fruitList :[Food] = []
    var vegList:[Food] = []
      var DictionaryFruit :[String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        langView.layer.cornerRadius = 10
        langView.layer.borderWidth = 0.5
        totalLbl.layer.cornerRadius = 12
        totalLbl.clipsToBounds = true
        bottomView.layer.cornerRadius = 10
        let font = UIFont.systemFont(ofSize: 20)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                              for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                              for: .selected)
        let titleTextAttributes = [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor: UIColor(red:242/255, green: 122/255, blue: 28/255, alpha: 1)]
        let titleTextAttribute = [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor: UIColor.gray]
            
            segmentControl.setTitleTextAttributes(titleTextAttribute, for: .normal)
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
       languageBtn.layer.cornerRadius = 15
        print( UIDevice.current.identifierForVendor?.uuidString)
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        bottomView.layer.borderWidth = 0.5
         menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "UserMenuViewController") as! UserMenuViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        checkOutbtn.layer.cornerRadius = 15
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
      //  fruitView.semanticContentAttribute = .forceLeftToRight
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            topView.semanticContentAttribute = .forceRightToLeft
            productLbL.text = "product".localized(lang: "ar")
            productLbL.textAlignment  = .right
            priceLbl.text = "price".localized(lang: "ar")
            quantityLbl.text = "quantity".localized(lang: "ar")
            pageTitleLBL.text = "makeOrder".localized(lang: "ar")
            pageTitleLBL.textAlignment = .right
            segmentControl.setTitle("vegetable".localized(lang: "ar"), forSegmentAt: 0)
            segmentControl.setTitle("fruits".localized(lang: "ar"), forSegmentAt: 1)
            dayDeliveryLbl.text = "dayDelivery".localized(lang: "ar")
            nightDeliveryLbl.text = "nightDelivery".localized(lang: "ar")
            nightTimeLbl.text = "timenight".localized(lang: "ar")
            dayTimeLbl.text = "timeMorning".localized(lang: "ar")
            checkOutbtn.setTitle("checkout".localized(lang: "ar"), for: .normal)
            //yourCartLBL.text = "yourCart".localized(lang: "ar")
           
            bottomView.semanticContentAttribute = .forceRightToLeft
           tableView.semanticContentAttribute = .forceRightToLeft
            MiddleView.semanticContentAttribute = .forceRightToLeft
            nightTimeLbl.textAlignment = .right
            dayTimeLbl.textAlignment = .right
            dayDeliveryLbl.textAlignment = .right
            nightDeliveryLbl.textAlignment = .right
         //   topView.semanticContentAttribute = .forceRightToLeft
       //     languageBtn.contentHorizontalAlignment = .right
        //     langView.semanticContentAttribute = .forceRightToLeft
          languageLbl.textAlignment = .right
        }else{
            productLbL.text = "PRODUCT"
              productLbL.textAlignment  = .left
            priceLbl.text = "PRICE"
            quantityLbl.text = "QUANTITY"
            languageLbl.textAlignment = .left
            pageTitleLBL.text = "Make Order"
             pageTitleLBL.textAlignment = .left
            MiddleView.semanticContentAttribute = .forceLeftToRight
            topView.semanticContentAttribute = .forceLeftToRight
            bottomView.semanticContentAttribute = .forceLeftToRight
            tableView.semanticContentAttribute = .forceLeftToRight
            nightTimeLbl.textAlignment = .left
            dayTimeLbl.textAlignment = .left
            dayDeliveryLbl.textAlignment = .left
            nightDeliveryLbl.textAlignment = .left
           
            // languageBtn.contentHorizontalAlignment = .left
           // langView.semanticContentAttribute = .forceLeftToRight
        }
       
        if lang == "ar" {
            totalLbl.text = "مجموع:\(0)"
        }else{
            totalLbl.text = "total:\(0)"
        }
          // fetchFromDatabase()
        
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            getData()
        }else{
            
           networkNotExist()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if refresh == true {
            refreshItem()
            //zeroItemFruit
             let lang = UserDefaults.standard.value(forKey: "lang") as! String
            if lang == "ar" {
                
                totalLbl.text = "مجموع:\(0)"
            }else{
               
                totalLbl.text = "total:\(0)"
            }
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "zeroItemFruit"), object: nil, userInfo: nil)
            refresh = false
        }
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:functionDelegate
    func refreshControlData(){
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            getData()
        }else{
            
            networkNotExist()
        }
    }
    func updateItemInCart(ItemId: Int, Quantity: Int) {// call when change value from original liast
        for item in cartList{
            if item.id == ItemId{
                item.quantity = Quantity
                updateDatabase(Id:ItemId,Quantity:Quantity)
                 tableView.reloadData()
            }
        }
        var sum  = 0.0
        for i in cartList {
            sum = sum + Double(i.quantity) * i.wekalaPrice!
        }
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            totalLbl.text = "مجموع:\(sum)"
        }else{
            totalLbl.text = "total:\(sum)"
        }
        
    }
    
    func plusToCart(index:Int){
        cartList[index].quantity = cartList[index].quantity + 1
        updateDatabase(Id:cartList[index].id!,Quantity:cartList[index].quantity)
        tableView.reloadData()
        var sum  = 0.0
        for i in cartList {
            sum = sum + Double(i.quantity) * i.wekalaPrice!
        }
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            totalLbl.text = "مجموع:\(sum)"
        }else{
            totalLbl.text = "total:\(sum)"
        }
        if cartList[index].category == "fruites" ||  cartList[index].category == "فواكه"
        {
            let imageDataDict:[String: Any] = ["quantity": cartList[index].quantity ,"id": cartList[index].id!]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatecartfruites"), object: nil, userInfo: imageDataDict)
        }else{
            let imageDataDict:[String: Any] = ["quantity": cartList[index].quantity ,"id": cartList[index].id!]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatecart"), object: nil, userInfo: imageDataDict)
        }
        
    }
    func minusToCart(index:Int){
        if cartList[index].quantity > 1 {
        cartList[index].quantity = cartList[index].quantity - 1
         updateDatabase(Id:cartList[index].id!,Quantity:cartList[index].quantity)
        tableView.reloadData()
        var sum  = 0.0
        for i in cartList {
            sum = sum + Double(i.quantity) * i.wekalaPrice!
        }
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            totalLbl.text = "مجموع:\(sum)"
        }else{
            totalLbl.text = "total:\(sum)"
        }
        if cartList[index].category == "fruites" ||  cartList[index].category == "فواكه"
        {
            let imageDataDict:[String: Any] = ["quantity": cartList[index].quantity ,"id": cartList[index].id!]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatecartfruites"), object: nil, userInfo: imageDataDict)
        }else{
            let imageDataDict:[String: Any] = ["quantity": cartList[index].quantity ,"id": cartList[index].id!]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatecart"), object: nil, userInfo: imageDataDict)
        }
            
        }else if cartList[index].quantity == 1{ // it become zero remove from cart
            deleteFromCart(index:index)
        }
    }
    func sendFood(){
        fetchFromDatabase()
        cartList = []
        for item in foodDatabase {
            for term in foodList{
                if item.id == term.id {
                    term.quantity = item.quantity
                    cartList.append(term)
                }
            }
        }
        tableView.reloadData()
        if cartList.count == 0 {
            bottomView.isHidden = true
            bottomHeight.constant = 0
        }else{
            bottomView.isHidden = false
            bottomHeight.constant =  120
        }
        var sum  = 0.0
        for i in cartList {
            sum = sum + Double(i.quantity) * i.wekalaPrice!
        }
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            totalLbl.text = "مجموع:\(sum)"
        }else{
            totalLbl.text = "total:\(sum)"
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendfruites"), object: nil, userInfo: nil)
    }
    func deleteFromCart(index:Int){
         removeFromDatabase(id:cartList[index].id!)
        
        let imageDataDict:[String: Any] = ["id": cartList[index].id!]
        if cartList[index].category == "fruites" ||  cartList[index].category == "فواكه"
        {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCartfruites"), object: nil, userInfo: imageDataDict)
        }else{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCart"), object: nil, userInfo: imageDataDict)
        }
        cartList.remove(at: index)
        if cartList.count == 0{
            bottomView.isHidden = true
             bottomHeight.constant = 0
        }
        tableView.reloadData()
        var sum  = 0.0
        for i in cartList {
            sum = sum + Double(i.quantity) * i.wekalaPrice!
        }
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            totalLbl.text = "مجموع:\(sum)"
        }else{
            totalLbl.text = "total:\(sum)"
        }
      
    }
    func refreshItem(){
        cartList = []
        tableView.reloadData()
        
    }
    func getData(){
        foodList = []
       fruitList = []
        vegList = []
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["language"] = lang   as AnyObject?
        let url = Constant.baseUrl + Constant.getItem
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
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
                                self.foodList.append(vegItem)
                                self.vegList.append(vegItem)
                            }
                            
                        }
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
                               self.foodList.append(fruitItem)
                                self.fruitList.append(fruitItem)
                            }
//                            var fruitDataDict:[[String: Any]] = []
//                            for item in self.fruitList{
//                                var fruitDict :[String:Any] = ["id": item.id! ,"name": item.name!,"market_price":item.marketPrice!,"wekal_price": item.wekalaPrice!,"unit":item.unit!,"packing_fees":item.packingFees!,"category":item.category!,"image":item.image]
//                                fruitDataDict.append(fruitDict)
//                            }
//                            self.DictionaryFruit  = ["fruit": fruitDataDict]
                            self.sendFood()
                            
                         
                            
                            // self.fruitCollectionView.reloadData()
                        }
                       
                    }
                    
                    
                    
                case .failure(let error):
                    print(error)
                    
                    self.networkFail()
                    
                }
        }
    
        
    }
    func fetchFromDatabase(){
        foodDatabase = []
        var context  : NSManagedObjectContext?
         if #available(iOS 10.0, *) {
             context = appdelegate.persistentContainer.viewContext
         }else{
            context =  Storage.shared.context
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CartFood")
        let data = UserDefaults.standard.data(forKey: "person")
        let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
        let predicate2 = NSPredicate(format: "customerId == '\((person?.id)!)'")
    
        request.predicate = predicate2
        
        request.returnsObjectsAsFaults = false // to return data as way as you saved it
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
                    foodDatabase.append(food)
         
                }
               
            }
        }catch{
            print("error to retrieve")
        }
      
    }
    
    func updateDatabase(Id:Int,Quantity:Int){
         var context  : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
             context = self.appdelegate.persistentContainer.viewContext
        }else{ // 9
             context = Storage.shared.context
        }
        let fetchRequest:NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName:"CartFood")
        let predicate = NSPredicate(format: "id == '\(Id)'")
        let data = UserDefaults.standard.data(forKey: "person")
        let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
        let predicate2 = NSPredicate(format: "customerId == '\((person?.id)!)'")
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        fetchRequest.predicate = predicates
        do{
            let test = try context?.fetch(fetchRequest)
            print("test\(test?.count)")
            if test?.count == 1
            {
                let objectUpdate = test![0] as! NSManagedObject
                objectUpdate.setValue(Quantity, forKey: "quantity")
                do {
                    try context?.save()
                    print("update")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
            
        }catch{
            print(error)
        }
    }
    func sendItemToCart(Item:Food,flag:Bool){
        if flag == true {
            cartList.append(Item)
            if cartList.count >= 1{
                bottomView.isHidden = false
                 bottomHeight.constant = 120
            }
            //add to database
            var context  : NSManagedObjectContext?
            if #available(iOS 10.0, *) {
                 context = self.appdelegate.persistentContainer.viewContext
               
            }else{ // 9
                context = Storage.shared.context
            }
            let cityData = NSEntityDescription.insertNewObject(forEntityName: "CartFood", into: context!)
            cityData.setValue(Item.id, forKey: "id")
            cityData.setValue(Item.quantity, forKey: "quantity")
            cityData.setValue(Item.name, forKey: "name")
            cityData.setValue(Item.added, forKey: "added")
            cityData.setValue(Item.category, forKey: "category")
            cityData.setValue(Item.image, forKey: "image")
            cityData.setValue(Item.marketPrice, forKey: "marketPrice")
            cityData.setValue(Item.packingFees, forKey: "packingFees")
            cityData.setValue(Item.unit, forKey: "unit")
            cityData.setValue(Item.wekalaPrice, forKey: "wekalaPrice")
            
            if let data = UserDefaults.standard.data(forKey: "person"){
                let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
                 cityData.setValue((person?.id)!, forKey: "customerId")
            }
           
            do{
                try context?.save()
                print("Saved")
                
            }catch{
                
                print("error")
            }
            
        }else{
            var index  = -1
            for i in  0..<cartList.count{
                if cartList[i].id! == Item.id! {
                    index = i
                    
                }
            }
            if index != -1 {
                cartList.remove(at: index)
            }
            if cartList.count == 0 {
                bottomView.isHidden = true
                 bottomHeight.constant = 0
            }
            //remove from database
             removeFromDatabase(id:Item.id!)
        }
        tableView.reloadData()
        var sum  = 0.0
        for i in cartList {
            sum = sum + Double(i.quantity) * i.wekalaPrice!
        }
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            totalLbl.text = "مجموع:\(sum)"
        }else{
            totalLbl.text = "total:\(sum)"
        }
        
    }
    func removeFromDatabase(id:Int){
        var context  : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
             context = self.appdelegate.persistentContainer.viewContext
        }else{ // 9
             context = Storage.shared.context
        }
        let fetchRequest:NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName:"CartFood")
        let predicate = NSPredicate(format: "id == '\(id)'")
          let data = UserDefaults.standard.data(forKey: "person")
          let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
        let predicate2 = NSPredicate(format: "customerId == '\((person?.id)!)'")
         let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        fetchRequest.predicate = predicates
        do{
            let  fetchedItems = try context?.fetch(fetchRequest)
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
    //MARK:IBAction
    
    @IBAction func menuBtn(_ sender: Any) {
        if  AppDelegate.userMenu_bool{
            showMenu()
        }else{
            closeMenu()
        }
    }
    
    @IBAction func languageBtnAction(_ sender: Any) {
        langView.isHidden = !langView.isHidden
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fruitNav"{
            let fruitViewContoller = segue.destination as! FruitViewController
            fruitViewContoller.sendCardDelegate = self
            fruitViewContoller.parentView = self
        }
        if segue.identifier == "vegNav"{
            let VegetableViewController = segue.destination as! VegetableViewController
            VegetableViewController.sendCardDelegate = self
             VegetableViewController.parentView = self
        }
        if segue.identifier == "myOrder"{
            let myorder =    segue.destination as! MyOrderViewController
            myorder.parentView = self.view
        }
    }
 
    @IBAction func arabicBtnAction(_ sender: Any) {
      //  cartList = []
       //    foodList = []
        productLbL.text = "product".localized(lang: "ar")
        priceLbl.text = "price".localized(lang: "ar")
        quantityLbl.text = "quantity".localized(lang: "ar")
         productLbL.textAlignment  = .right
        if tab == 0{
             pageTitleLBL.text = "makeOrder".localized(lang: "ar")
        }else if tab == 1{
            pageTitleLBL.text = "myProfile".localized(lang: "ar")
        }else {
            pageTitleLBL.text = "myOrder".localized(lang: "ar")
        }
        pageTitleLBL.textAlignment = .right
         languageLbl.text = "Arabic"
          pageTitleLBL.textAlignment = .right
          languageLbl.textAlignment = .right
        MiddleView.semanticContentAttribute = .forceRightToLeft
        topView.semanticContentAttribute = .forceRightToLeft
     //   languageBtn.contentHorizontalAlignment = .right
       //  langView.semanticContentAttribute = .forceLeftToRight
        nightTimeLbl.textAlignment = .right
        dayTimeLbl.textAlignment = .right
        dayDeliveryLbl.textAlignment = .right
        nightDeliveryLbl.textAlignment = .right
         langView.isHidden = true
         UserDefaults.standard.set("ar", forKey: "lang")
        segmentControl.setTitle("vegetable".localized(lang: "ar"), forSegmentAt: 0)
        segmentControl.setTitle("fruits".localized(lang: "ar"), forSegmentAt: 1)
        dayDeliveryLbl.text = "dayDelivery".localized(lang: "ar")
        nightDeliveryLbl.text = "nightDelivery".localized(lang: "ar")
        nightTimeLbl.text = "timenight".localized(lang: "ar")
        dayTimeLbl.text = "timeMorning".localized(lang: "ar")
        checkOutbtn.setTitle("checkout".localized(lang: "ar"), for: .normal)
       // yourCartLBL.text = "yourCart".localized(lang: "ar")
       
        bottomView.semanticContentAttribute = .forceRightToLeft
             tableView.semanticContentAttribute = .forceRightToLeft
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLang"), object: nil, userInfo: nil)
       //  itemView.semanticContentAttribute = .forceRightToLeft
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeMenuLanguage"), object: nil, userInfo: nil)
        if tab == 0 {
            getData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLang"), object: nil, userInfo: nil)
        }else if tab == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyOrder"), object: nil, userInfo: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeProfileLanguage"), object: nil, userInfo: nil)
        }
    }
    @IBAction func englishBtnAction(_ sender: Any) {
     //   cartList = []
      //  foodList = []
        if tab == 0{
            pageTitleLBL.text =  "Make Order"
        }else if tab == 1{
            pageTitleLBL.text =  "My Profile"
        }else {
            pageTitleLBL.text =  "My Orders"
        }
         productLbL.textAlignment = .left
        productLbL.text = "PRODUCT"
        priceLbl.text = "PRICE"
        quantityLbl.text = "QUANTITY"
        pageTitleLBL.textAlignment = .left
        languageLbl.text = "English"
          languageLbl.textAlignment = .left
        nightTimeLbl.textAlignment = .left
        dayTimeLbl.textAlignment = .left
        dayDeliveryLbl.textAlignment = .left
        nightDeliveryLbl.textAlignment = .left
        MiddleView.semanticContentAttribute = .forceLeftToRight
        topView.semanticContentAttribute = .forceLeftToRight
        bottomView.semanticContentAttribute = .forceLeftToRight
  //      langView.semanticContentAttribute = .forceLeftToRight
         langView.isHidden = true
         UserDefaults.standard.set("en", forKey: "lang")
        segmentControl.setTitle("vegetable".localized(lang: "en"), forSegmentAt: 0)
        segmentControl.setTitle("fruits".localized(lang: "en"), forSegmentAt: 1)
        dayDeliveryLbl.text = "dayDelivery".localized(lang: "en")
        nightDeliveryLbl.text = "nightDelivery".localized(lang: "en")
        nightTimeLbl.text = "timenight".localized(lang: "en")
        dayTimeLbl.text = "timeMorning".localized(lang: "en")
        checkOutbtn.setTitle("checkout".localized(lang: "en"), for: .normal)
       
        
        bottomView.semanticContentAttribute = .forceLeftToRight
             tableView.semanticContentAttribute = .forceLeftToRight
       //  itemView.semanticContentAttribute = .forceLeftToRight
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeMenuLanguage"), object: nil, userInfo: nil)
        if tab == 0 {
             getData()
             // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLang"), object: nil, userInfo: nil)
        }else if tab == 2 {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyOrder"), object: nil, userInfo: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeProfileLanguage"), object: nil, userInfo: nil)
        }
        //
    }
    @IBAction func segmentControlAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            vegView.isHidden = false
            fruitView.isHidden = true
            
        case 1:
            vegView.isHidden = true
            fruitView.isHidden = false
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMap"), object: nil, userInfo: nil)
        default:
            print("")
        }
    }
    
    @IBAction func checkOutBtnAction(_ sender: Any) {
        var cartData = CartData()
          cartData.cartList = cartList
        if cartList.count > 0 {
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "TimeViewController") as! TimeViewController
        popupVC.cartData = cartData
        self.addChildViewController(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        }else{
            let lang = UserDefaults.standard.value(forKey: "lang") as! String
            if lang == "ar" {
            let alert = UIAlertController(title: "", message: "أضف إلى العربة" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "Add to cart" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
extension MakeOrderViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartList.count > 0 {
            return cartList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CartTableViewCell
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
           cell.name.textAlignment = .right
            cell.contentView.semanticContentAttribute = .forceRightToLeft
        }else{
            cell.name.textAlignment =  .left
             cell.contentView.semanticContentAttribute =  .forceLeftToRight
        }
       
        cell.index = indexPath.row
        cell.cartAction = self 
        cell.name.text = cartList[indexPath.row].name!
        cell.quantity.text = "\(cartList[indexPath.row].quantity)"
        cell.unit.text = cartList[indexPath.row].unit!
        return cell
    }
}
extension MakeOrderViewController :menuDelegate{
    //MARK:MENU FUnction
    @objc func respondToGesture(gesture:UISwipeGestureRecognizer){
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            switch gesture.direction{
            case UISwipeGestureRecognizerDirection.right:
                print("right")
                
                close_on_swipe()
            case UISwipeGestureRecognizerDirection.left:
                print("left Swipe")
                showMenu()
            default:
                print("")
            }
        }else{
            switch gesture.direction{
            case UISwipeGestureRecognizerDirection.right:
                print("right")
                showMenu()
            case UISwipeGestureRecognizerDirection.left:
                print("left Swipe")
                close_on_swipe()
            default:
                print("")
            }
        }
        
    }
    func close_on_swipe(){
        if  AppDelegate.userMenu_bool{
            
        }else{
            closeMenu()
        }
    }
    @objc func MenuButtonTapped() {
        print("Button Tapped")
        if  AppDelegate.userMenu_bool{
            showMenu()
        }else{
            closeMenu()
        }
    }
    func showMenu(){
        UIView.animate(withDuration: 0.3){ ()->Void in
            self.menu_vc.view.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.menu_vc.menuDel = self
            self.addChildViewController(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.userMenu_bool = false
        }
        
    }
    func closeMenu(){
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menu_vc.view.frame = CGRect(x:-UIScreen.main.bounds.size.width,y:60,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.menu_vc.view.removeFromSuperview()
        }
        
        AppDelegate.userMenu_bool = true
    }
    func menuActionDelegate(number:Int){
        AppDelegate.userMenu_bool = true
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        switch number{
        case 0:
            print("Home")
            let lang = UserDefaults.standard.value(forKey: "lang") as! String
            if lang == "ar" {
                  pageTitleLBL.text = "makeOrder".localized(lang: "ar")
            }else{
               pageTitleLBL.text = "Make Order"
            }
          myOrderView.isHidden =  true
            tab = 0
        
            myProfileView.isHidden = true
            getData()
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLang"), object: nil, userInfo: nil)
        case 1:
            print("my profile")
            if lang == "ar" {
                pageTitleLBL.text = "myProfile".localized(lang: "ar")
               
            }else{
              pageTitleLBL.text = "My Profile"
            }
            tab = 1
            myOrderView.isHidden = true
            myProfileView.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyProfile"), object: nil, userInfo: nil)
        case 2:
            print("myorder")
            tab = 2
            if lang == "ar" {
               pageTitleLBL.text = "myOrder".localized(lang: "ar")
            }else{
                 pageTitleLBL.text = "My Orders"
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyOrder"), object: nil, userInfo: nil)
            myOrderView.isHidden = false
            myProfileView.isHidden = true
            
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrdersViewController") as! CancelOrdersViewController
            //
            //            self.addChildViewController(vc)
            //            self.view.addSubview(vc.view)
            
        default:
            print("")
            
        }
    }
    

}
