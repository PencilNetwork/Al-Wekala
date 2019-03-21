//
//  LocationViewController.swift
//  ALWekala
//
//  Created by Mac on 10/24/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class LocationViewController: UIViewController ,MapDelegate{
    @IBOutlet weak var defaultAddressLbl: UILabel!
    @IBOutlet weak var addressCheckBox: UIButton!
    @IBOutlet weak var landscapeTxt: UITextField!
    
    @IBOutlet weak var defaultRegion: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var selectedAddressLbl: UILabel!
    @IBOutlet weak var setYourLocationBtn: UIButton!
    @IBOutlet weak var flatNumberTxt: UITextField!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var createAddressLBL: UILabel!
    @IBOutlet weak var defaultFlatLBL: UILabel!
    @IBOutlet weak var chooseLocation: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var defaultCheckBox: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var regionBtnDone: UIButton!
    @IBOutlet weak var regionPickerView: UIPickerView!
    //MARK:variable
    var regionList:[RegionBean] = []
    var regionSelected = -1
    var defaultFlag = true
    var addressFlag = false
    var locationFlag = false
    var lat = 0.0
    var long = 0.0
    var address:String?
    var cartData :CartData?
      let lang = UserDefaults.standard.value(forKey: "lang") as! String
    var comparedString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         defaultCheckBox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
          self.navigationController?.navigationBar.backItem?.title = ""
        confirmBtn.layer.cornerRadius = 20
        setYourLocationBtn.layer.cornerRadius = 25
        if lang == "ar" {
              contentView.semanticContentAttribute = .forceRightToLeft
            defaultLabel.textAlignment = .right
            createAddressLBL.textAlignment = .right
             chooseLocation.text = "حدد موقعك"
             regionBtn.setTitle("region".localized(lang: "ar"), for: .normal)
             flatNumberTxt.placeholder = "flatNumber".localized(lang: "ar")
             landscapeTxt.placeholder = "landscape".localized(lang: "ar")
            setYourLocationBtn.setTitle("اختر موقعك الجديد", for: .normal)
            createAddressLBL.text = "createNewAddress".localized(lang: "ar")
            confirmBtn.setTitle("confirm".localized(lang: "ar"), for: .normal)
            defaultLabel.text = "defaultAddress".localized(lang: "ar")
            regionBtn.contentHorizontalAlignment = .right
            flatNumberTxt.textAlignment = .right
            defaultRegion.textAlignment = .right
            landscapeTxt.textAlignment = .right
            defaultFlatLBL.textAlignment = .right
            defaultAddressLbl.textAlignment = .right
            selectedAddressLbl.textAlignment = .right
        }else{
            contentView.semanticContentAttribute = .forceLeftToRight
             selectedAddressLbl.textAlignment = .left
             flatNumberTxt.textAlignment = .left
             landscapeTxt.textAlignment = .left
             defaultRegion.textAlignment = .left
            defaultAddressLbl.textAlignment = .left
            defaultFlatLBL.textAlignment = .left
            regionBtn.contentHorizontalAlignment = .left
            defaultLabel.textAlignment = .left
            createAddressLBL.textAlignment = .left
        }
        if let data = UserDefaults.standard.data(forKey: "person"){
            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
            print("ewrw person\(person?.name)")
            defaultAddressLbl.text =  (person?.address)!
            
            if lang == "ar" {
                defaultFlatLBL.text = "رقم الشقة:" + " \((person?.flat_number)!)"
              //  defaultRegion.text = "المنطقة: " + (person?.regoin)!
            }else{
               defaultFlatLBL.text = "Flat Number: \((person?.flat_number)!)"
              //  defaultRegion.text = "Region: " + (person?.regoin)!
            }
           
        }
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
               getRegion()
            
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       flatNumberTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        landscapeTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
        txtStyle(txtfield:landscapeTxt)
        txtStyle(txtfield:flatNumberTxt)
        regionBtn.layer.cornerRadius = 25
        regionBtn.clipsToBounds = true
        regionBtn.layer.borderWidth = 1
        regionBtn.layer.borderColor = UIColor(red:201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
    }
    func txtStyle(txtfield:UITextField){
        txtfield.layer.cornerRadius = 25
        txtfield.clipsToBounds = true
        txtfield.layer.borderWidth = 1
        txtfield.layer.borderColor = UIColor(red:201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = ""
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
  //      self.navigationController?.isNavigationBarHidden = true
    }
    //MARK:Function
    func getRegion(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let url = Constant.baseUrl + Constant.getRegion
        print(url)
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [[String:Any]]{
                        if datares.count > 0 {
                            let defaultRegion = RegionBean()
                            defaultRegion.id = -1
                            let lang = UserDefaults.standard.value(forKey: "lang") as! String
                            if lang == "ar" {
                                defaultRegion.arName = "اختار المنطقة"
                            }else{
                                defaultRegion.enName = "Select Region"
                            }
                            
                            self.regionList.append(defaultRegion)
                        }
                        for item in datares{
                            var region = RegionBean()
                            if let id = item["id"] as? Int {
                                region.id = id
                            }
                            if let name = item["name_en"] as? String{
                                region.enName = name
                            }
                            if let arName = item["name_ar"] as? String{
                                region.arName = arName
                            }
                            if let fees = item["fees"] as? Double{
                                region.deliveryfees = fees
                            }
                            self.regionList.append(region)
                        }
                        self.regionPickerView.dataSource = self
                        self.regionPickerView.delegate = self
                        
                        if let data = UserDefaults.standard.data(forKey: "person"){
                            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
                             let lang = UserDefaults.standard.value(forKey: "lang") as! String
                            let region = Int((person?.regoin)!)
                            
                            for item in self.regionList{
                                if item.id! == region{
                                    if lang == "ar" {
                                        
                                        self.defaultRegion.text = "المنطقة: " + (item.arName)!
                                    }else{
                                        
                                        self.defaultRegion.text = "Region: " + (item.enName)!
                                    }
                                }
                            }
                        }
                       
                    }
                case .failure(let error):
                    print(error)
                    
                   
                    
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "retry", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.getRegion()
                    }))
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
    func createMap(lat:Double,long:Double,Address:String,region:String){
        self.lat = lat
        self.long = long
        self.address = Address
        self.selectedAddressLbl.text = self.address
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func checkTxtField()->Bool{
        var validFlag = true
        if flatNumberTxt.text == "" {
            validFlag = false
            flatNumberTxt.backgroundColor = .red
            
        }
        if landscapeTxt.text  == "" {
            validFlag = false
            landscapeTxt.backgroundColor = .red
            
        }
        if regionSelected == -1{
            validFlag = false
            
            if lang == "ar"
            {
                let alert = UIAlertController(title: "", message: "اختار المنطقة" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:  "حسنا", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "Select region" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        if locationFlag == false  {
            validFlag = false
            
            if lang == "ar"
            {
                let alert = UIAlertController(title: "", message: "حدد موقعك" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:  "حسنا", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "select your location" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            if address == "" || long == 0 && lat == 0 {
                 validFlag = false
                if lang == "ar"
                {
                    let alert = UIAlertController(title: "", message: "حدد موقعك" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:  "حسنا", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "", message: "select your location" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return validFlag
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.backgroundColor = UIColor.white
        
    }
    //MARK:IBAction
    @IBAction func defaultCheckBoxAction(_ sender: Any) {
        defaultFlag = !defaultFlag
        if defaultFlag == true {
            defaultCheckBox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
            addressCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
            addressFlag = false
        }else{
            defaultCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
        }
    }
    @IBAction func addressCheckBoxAction(_ sender: Any) {
        addressFlag = !addressFlag
        if addressFlag == true {
            defaultCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
            addressCheckBox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
            defaultFlag = false
        }else{
            addressCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
        }
    }
    
    @IBAction func regionBtnAction(_ sender: Any) {
        regionBtnDone.isHidden = !regionBtnDone.isHidden
        regionPickerView.isHidden = !regionPickerView.isHidden
    }
    @IBAction func setYourLocationAction(_ sender: Any) {
        locationFlag = true
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AnotherMapViewController") as! AnotherMapViewController
        viewController.mapDelegate = self
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        if defaultFlag == true || addressFlag == true {
            if defaultFlag == true {
                cartData?.address  = defaultAddressLbl.text!
                if let data = UserDefaults.standard.data(forKey: "person"){
                    let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
                    print("ewrw person\(person?.name)")
                    
                    cartData?.flatNumber =  (person?.flat_number)!
                    cartData?.latitude =  (person?.latitude)!
                    cartData?.longitude = (person?.langitude)!
                    cartData?.region = (person?.regoin)!
                    cartData?.beside = (person?.besides)!
                    for item in regionList {
                        if item.id  == Int((cartData?.region!)!) {
                            cartData?.deliveryfees = item.deliveryfees!
                        }
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmedOrderViewController") as! ConfirmedOrderViewController
                    vc.cartData = cartData
                    vc.comparedString = comparedString
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if addressFlag == true {
                let valid = checkTxtField()
                if valid == true{
               cartData?.address  = address!
                cartData?.flatNumber = flatNumberTxt.text!
              cartData?.region = "\(regionList[regionSelected].id!)"
                    cartData?.deliveryfees = regionList[regionSelected].deliveryfees!
                cartData?.longitude = "\(long)"
                 cartData?.latitude =  "\(lat)"
                cartData?.beside = landscapeTxt.text!
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmedOrderViewController") as! ConfirmedOrderViewController
                    vc.cartData = cartData
                    vc.comparedString = comparedString
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
        }else{
            let lang = UserDefaults.standard.value(forKey: "lang") as! String
            if lang == "ar" {
                let alert = UIAlertController(title: "", message: "حدد موقعك", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "select your location", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func regionBtnDone(_ sender: Any) {
        regionPickerView.isHidden = true
        regionBtnDone.isHidden = true
    }
}
extension LocationViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    //MARK:pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if regionList.count > 0{
            return regionList.count
        }else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
            return regionList[row].arName
        }else{
            return regionList[row].enName
        }
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            regionSelected = -1
            
            
            
        }else{
            regionSelected = row
            
        }
        
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
            regionBtn.setTitle(regionList[row].arName, for: .normal)
        }else{
            regionBtn.setTitle(regionList[row].enName, for: .normal)
        }
        
        
    }
}
extension UIViewController{
    func networkFail (){
        let  lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            let alert = UIAlertController(title: "", message:"خطأ في الشبكة" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func networkNotExist(){
        let  lang = UserDefaults.standard.value(forKey: "lang") as! String
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
