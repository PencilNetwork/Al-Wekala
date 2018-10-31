//
//  MyProfileViewController.swift
//  ALWekala
//
//  Created by Mac on 10/28/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class MyProfileViewController: UIViewController ,MapDelegate{
    
  //  @IBOutlet weak var regiointry: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var alexandria: UITextField!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var regionDone: UIButton!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var setLocationBtn: UIButton!
    @IBOutlet weak var landscapetxt: UITextField!
    @IBOutlet weak var flatNumberTxt: UITextField!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var numberTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var flatNumber: UILabel!
    
    @IBOutlet weak var landscape: UILabel!
    var regionList:[RegionBean] = []
    var regionSelected = -1
    var lat = 0.0
    var long = 0.0
    var address:String?
    var up = false
    var locationFlag = false
    var regionMap = ""
      let lang = UserDefaults.standard.value(forKey: "lang") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        hideKeyboardWhenTappedAround()
        confirmBtn.layer.cornerRadius = 10
        setLocationBtn.layer.cornerRadius = 10
        landscapetxt.delegate = self
        flatNumberTxt.delegate = self
        numberTxt.delegate = self
        nameTxt.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(MyProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(myProfile(_:)), name: NSNotification.Name(rawValue: "MyProfile"), object: nil)
        // Do any additional setup after loading the view.
        //
         NotificationCenter.default.addObserver(self, selector: #selector(changeLang(_:)), name: NSNotification.Name(rawValue: "changeProfileLanguage"), object: nil)
        if let data = UserDefaults.standard.data(forKey: "person"){
            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
           
            nameTxt.text = person?.name
            numberTxt.text = person?.phone
            regionBtn.setTitle(person?.regoin, for: .normal)
            flatNumberTxt.text = person?.flat_number
            landscapetxt.text = person?.besides
            lat = Double((person?.latitude)!)!
            long = Double((person?.langitude)!)!
            self.address = (person?.address)!
            self.addressLBL.text = (person?.address)!
        }
    }
    func arabicLang(){
        nameTxt.placeholder = "name".localized(lang: "ar")
        confirmBtn.setTitle("confirm".localized(lang: "ar"), for: .normal)
        setLocationBtn.setTitle("setYourLocation".localized(lang: "ar"), for: .normal)
       
     //   regionBtn.setTitle("region".localized(lang: "ar"), for: .normal)
        numberTxt.placeholder = "number".localized(lang: "ar")
        alexandria.placeholder = "alexandria".localized(lang: "ar")
        landscapetxt.placeholder = "landscape".localized(lang: "ar")
        contentView.semanticContentAttribute = .forceRightToLeft
        nameTxt.textAlignment = .right
        numberTxt.textAlignment = .right
        alexandria.textAlignment = .right
        regionBtn.contentHorizontalAlignment = .right
        flatNumberTxt.textAlignment = .right
        landscapetxt.textAlignment = .right
        flatNumber.text = "flatNumber".localized(lang: "ar")
        landscape.text = "landscape".localized(lang: "ar")
    }
    func englishLang(){
        nameTxt.placeholder = "name"
        confirmBtn.setTitle("Confirm editing", for: .normal)
        setLocationBtn.setTitle("Edit Your Location", for: .normal)
        
      //  regionBtn.setTitle("region", for: .normal)
        numberTxt.placeholder = "Phone"
        alexandria.placeholder = "Alexandria"
        landscapetxt.placeholder = "landscape"
        contentView.semanticContentAttribute = .forceLeftToRight
        nameTxt.textAlignment = .left
        numberTxt.textAlignment = .left
        alexandria.textAlignment = .left
        regionBtn.contentHorizontalAlignment = .left
        flatNumberTxt.textAlignment = .left
        landscapetxt.textAlignment = .left
        flatNumber.text = "Flat Number"
        landscape.text = "landscape"
    
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if up == true {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                // if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                
                //}
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if up == true {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                //  if self.view.frame.origin.y != 0{
                //                self.view.frame.origin.y += keyboardSize.height
                self.view.frame.origin.y  = 0
                // }
            }
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if  textField.tag == 3{
            up = true
        }else{
            up = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func myProfile(_ notification: NSNotification){
        getRegion()
           let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
            
            arabicLang()
        }else {
            englishLang()
        }
        
    }
      @objc func changeLang(_ notification: NSNotification){
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
            
            arabicLang()
        }else {
            englishLang()
        }
     }
    //MARK:IBAction
    @IBAction func regionBtnDone(_ sender: Any) {
        regionPickerView.isHidden = true
        regionDone.isHidden = true
         self.showToastAnother(message: "please make sure from your location")
    }
    @IBAction func regionBtnAction(_ sender: Any) {
        regionPickerView.isHidden = !regionPickerView.isHidden
        regionDone.isHidden = !regionDone.isHidden
    }
    @IBAction func confirmBtnAction(_ sender: Any) {
        let valid = checkTxtField()
        if valid == true{
            let network = Network()
            let networkExist = network.isConnectedToNetwork()
            
            if networkExist == true {
//                 if regionSelected != -1 {
////                    if regionMap != "" {
////                        if  regionMap.range(of:regionList[regionSelected].name! , options: .caseInsensitive) != nil {
////                            print("\(regionList[regionSelected].name!) ////  \(regionMap) ")
////                        sendData()
////                       }else{ // not equal
////                            print("\(regionList[regionSelected].name!) ////  \(regionMap) ")
////                        let alert = UIAlertController(title: "Warning", message: "You should change regoin to \(regionMap)", preferredStyle: UIAlertControllerStyle.alert)
////                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
////                        self.present(alert, animated: true, completion: nil)
////                      }
//                    }else{
//                        sendData()
//                    }
//                 }else{
               sendData()
//                }
            }else{
                
                let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func setLocationBtnAction(_ sender: Any) {
        locationFlag = true
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AnotherMapViewController") as! AnotherMapViewController
        viewController.mapDelegate = self
        self.navigationController?.pushViewController(viewController, animated: false)
    }

    func sendData(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
       
        var parameter :[String:AnyObject] = [String:AnyObject]()
        let data = UserDefaults.standard.data(forKey: "person")
        let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
        
        parameter["id"] =  (person?.id)!  as  AnyObject?
        print((person?.id)!)
        parameter["social_id"] = (person?.social_id)! as  AnyObject?
        parameter["name"] = nameTxt.text! as AnyObject?
        parameter["token"] = "token"   as AnyObject?
        parameter["phone"] = numberTxt.text! as  AnyObject?
        parameter["address"] = self.address! as  AnyObject?
        parameter["flat_number"] = flatNumberTxt.text! as  AnyObject?
      
        parameter["langitude"] = self.long as  AnyObject?
        parameter["latitude"] = self.lat as  AnyObject?
        parameter["city"] = "Alexandria" as  AnyObject?
        if regionSelected == -1 {
             parameter["regoin"] = (person?.regoin)!  as  AnyObject?
        }else{
             parameter["regoin"] = regionList[regionSelected].name!  as  AnyObject?
        }
       
        parameter["besides"] = landscapetxt.text!  as  AnyObject?
        parameter["language"] = lang as  AnyObject?
        let url = Constant.baseUrl + Constant.updateCustomer
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let flag = datares["flag"] as? String{
                            if flag == "0"{
                                if let errors = datares["errors"] as? String {
                                    self.showToast(message : errors)
                                }
                            }else{
                                
                              self.showToast(message :"successful update")
                                var region = ""
                                if self.regionSelected == -1 {
                                   region = (person?.regoin)!
                                }else{
                                    region = self.regionList[self.regionSelected].name!
                                }
                                 let data = UserDefaults.standard.data(forKey: "person")
                                let person = NSKeyedUnarchiver.unarchiveObject(with: data!) as? Person
                                
                                
                                var updatePerson = Person(id:"\((person?.id)!)",name:self.nameTxt.text! ,token: (person?.token)! ,phone:self.numberTxt.text! ,address:self.addressLBL.text! ,flat_number:self.flatNumberTxt.text! ,social_id:(person?.social_id)! ,long: "\(self.long as! Double)" ,lat:"\(self.lat)",city:"Alexandria",regoin:region,besides:self.landscapetxt.text! ,created_at: "",updated_at:"")
                                        let encodeData =  NSKeyedArchiver.archivedData(withRootObject: updatePerson)
                                        UserDefaults.standard.set(encodeData, forKey: "person")
                                        if let data = UserDefaults.standard.data(forKey: "person"){
                                            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
                                            print("ewrw person\(person?.name)")
                                        }
                                
                                
                                
                             
                                
                                /////
                                
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
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.backgroundColor = UIColor.white
        
    }
   
    
   
    func checkTxtField()->Bool{
        var validFlag = true
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if nameTxt.text == "" {
            validFlag = false
            nameTxt.backgroundColor = .red
        }
        if numberTxt.text == "" {
            validFlag = false
            numberTxt.backgroundColor = .red
        }else{
            if (numberTxt.text?.count)! < 11{
                validFlag = false
                if lang == "ar"
                {
                    let alert = UIAlertController(title: "", message:"رقم الجوال يجب أن لا يقل عن 11 رقم", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "alert", message: "mobile number should not less than 11 number", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }

        if flatNumberTxt.text == "" {
            validFlag = false
            flatNumberTxt.backgroundColor = .red
        }
        if landscapetxt.text == "" {
            validFlag = false
            landscapetxt.backgroundColor = .red
        }
        
        return validFlag
    }
    func createMap(lat:Double,long:Double,Address:String,region:String){
        self.lat = lat
        self.long = long
        self.address = Address
        self.addressLBL.text = self.address
        self.regionMap = region
        if regionSelected == -1 {
            self.showToastAnother(message: "please make sure from your region")
        }
       // regiointry.text = region
    }
    func getRegion(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let url = Constant.baseUrl + Constant.getRegion
        print(url)
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [[String:Any]]{
                        if datares.count > 0 {
                            let defaultRegion = RegionBean()
                            defaultRegion.id = -1
                            let lang = UserDefaults.standard.value(forKey: "lang") as! String
                            if lang == "ar" {
                                defaultRegion.name = "اختار المنطقة"
                            }else{
                                defaultRegion.name = "Select Region"
                            }
                            
                            self.regionList.append(defaultRegion)
                        }
                        for item in datares{
                            var region = RegionBean()
                            if let id = item["id"] as? Int {
                                region.id = id
                            }
                            if let name = item["name"] as? String{
                                region.name = name
                            }
                            self.regionList.append(region)
                        }
                        self.regionPickerView.dataSource = self
                        self.regionPickerView.delegate = self
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension MyProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource{
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
        
        return regionList[row].name
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            regionSelected = -1
            
            
            
        }else{
            regionSelected = row
            
        }
       
        regionBtn.setTitle(regionList[row].name, for: .normal)
        
        
    }
}
extension MyProfileViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberTxt {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 11 // Bool
        }else{
            return true
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    //     func textFieldDidEndEditing(_ textField: UITextField){
    //        let nextTag = textField.tag + 1
    //
    //        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
    //            nextResponder.becomeFirstResponder()
    //        } else {
    //            textField.resignFirstResponder()
    //        }
    //    }
}
