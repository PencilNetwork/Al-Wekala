//
//  SignUpViewController.swift
//  ALWekala
//
//  Created by Mac on 10/21/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class SignUpViewController: UIViewController,MapDelegate {

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
    var regionList:[RegionBean] = []
    var regionSelected = -1
    var lat = 0.0
    var long = 0.0
    var address:String?
    var up = false
    var locationFlag = false
    override func viewDidLoad() {
        super.viewDidLoad()
         getRegion()
        txtStyle(txtfield:nameTxt)
        txtStyle(txtfield:numberTxt)
        txtStyle(txtfield:alexandria)
        txtStyle(txtfield:flatNumberTxt)
        txtStyle(txtfield:landscapetxt)
        regionBtn.layer.cornerRadius = 25
        regionBtn.clipsToBounds = true
        regionBtn.layer.borderWidth = 1
        regionBtn.layer.borderColor = UIColor(red:201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        hideKeyboardWhenTappedAround()
        confirmBtn.layer.cornerRadius = 20
        setLocationBtn.layer.cornerRadius = 25
        landscapetxt.delegate = self
        flatNumberTxt.delegate = self
        numberTxt.delegate = self
        nameTxt.delegate = self
         let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
            
            nameTxt.placeholder = "name".localized(lang: "ar")
            confirmBtn.setTitle("confirm".localized(lang: "ar"), for: .normal)
            setLocationBtn.setTitle("setYourLocation".localized(lang: "ar"), for: .normal)
            flatNumberTxt.placeholder = "flatNumber".localized(lang: "ar")
            regionBtn.setTitle("region".localized(lang: "ar"), for: .normal)
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
            addressLBL.textAlignment = .right
        }else{
            contentView.semanticContentAttribute = .forceLeftToRight
            nameTxt.textAlignment = .left
            numberTxt.textAlignment = .left
            alexandria.textAlignment = .left
            regionBtn.contentHorizontalAlignment = .left
            flatNumberTxt.textAlignment = .left
            landscapetxt.textAlignment = .left
            addressLBL.textAlignment = .left
        }
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        landscapetxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        flatNumberTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        nameTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        numberTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:IBaction

    @IBAction func regionBtnDone(_ sender: Any) {
        regionPickerView.isHidden = true
        regionDone.isHidden = true 
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
            sendData()
            
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
    //MARK:Function
    func txtStyle(txtfield:UITextField){
        txtfield.layer.cornerRadius = 25
        txtfield.clipsToBounds = true
        txtfield.layer.borderWidth = 1
        txtfield.layer.borderColor = UIColor(red:201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.backgroundColor = UIColor.white
        
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
    func checkTxtField()->Bool{
        var validFlag = true
           let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if nameTxt.text == "" {
            validFlag = false
            nameTxt.backgroundColor = .red
        }else{
            
            let name = nameTxt.text!
            if name.count < 3{
                validFlag = false
                if lang == "ar"
                {
                    let alert = UIAlertController(title: "", message:"يجب أن يكون الاسم 3 أحرف على الأقل", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "alert", message: "Name should be at least 3 character", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        if numberTxt.text == "" {
            validFlag = false
            numberTxt.backgroundColor = .red
        }else{
            if (numberTxt.text?.count)! < 11{
                validFlag = false
                if lang == "ar"
                {
                    let alert = UIAlertController(title: "", message:"رقم الجوال غير صالح", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "alert", message: "Invalid mobile number", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
               
            }
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
        if flatNumberTxt.text == "" {
            validFlag = false
            flatNumberTxt.backgroundColor = .red
        }
        if landscapetxt.text == "" {
            validFlag = false
             landscapetxt.backgroundColor = .red
        }
        if locationFlag == false  {
            validFlag = false
            let lang = UserDefaults.standard.value(forKey: "lang") as! String
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
        return validFlag
    }
   func createMap(lat:Double,long:Double,Address:String,region:String){
        self.lat = lat
        self.long = long
        self.address = Address
        self.addressLBL.text = self.address
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
    func sendData(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        let socialId = UserDefaults.standard.value(forKey: "socialId") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
        
        parameter["name"] = nameTxt.text! as AnyObject?
        parameter["token"] = "token"   as AnyObject?
        parameter["phone"] = numberTxt.text! as  AnyObject?
        parameter["address"] = addressLBL.text! as  AnyObject?
        parameter["flat_number"] = flatNumberTxt.text! as  AnyObject?
        parameter["social_id"] =  socialId  as  AnyObject?
        parameter["langitude"] = self.long as  AnyObject?
        parameter["latitude"] = self.lat as  AnyObject?
        parameter["city"] = "Alexandria" as  AnyObject?
        parameter["regoin"] = "\(regionList[regionSelected].id!)"  as  AnyObject?
        parameter["besides"] = landscapetxt.text!  as  AnyObject?
        parameter["language"] = lang as  AnyObject?
        let url = Constant.baseUrl + Constant.signupUrl
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
                                
                                if let customer = datares["customer"] as? [String:Any]{
                                       UserDefaults.standard.set(true, forKey: "LoginEnter")
                                    if let id = customer["id"] as? Int {
                                        print("id\(id)")
                                        var person = Person(id:"\(id)",name:customer["name"] as! String ,token: customer["token"] as! String,phone:customer["phone"] as! String,address:customer["address"] as! String,flat_number:customer["flat_number"] as! String,social_id:customer["social_id"] as! String,long: "\(customer["langitude"] as! Double)" ,lat:"\(customer["latitude"] as! Double)",city:customer["city"] as! String,regoin:customer["regoin"] as! String,besides:customer["besides"] as! String,created_at:customer["created_at"] as! String,updated_at:customer["updated_at"] as! String)
                                        let encodeData =  NSKeyedArchiver.archivedData(withRootObject: person)
                                        UserDefaults.standard.set(encodeData, forKey: "person")
                                        if let data = UserDefaults.standard.data(forKey: "person"){
                                            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
                                            print("ewrw person\(person?.name)")
                                        }
                                        
                                    }
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeOrderViewController") as! MakeOrderViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
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
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension SignUpViewController: UIPickerViewDelegate,UIPickerViewDataSource{
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
extension SignUpViewController: UITextFieldDelegate{
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
     func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if  textField.tag == 3{
            up = true
        }else{
            up = false
        }
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
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x:  40, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
func showToastAnother(message : String) {
    
    let toastLabel = UILabel(frame: CGRect(x:  5, y: self.view.frame.size.height-100, width: 350, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 5.0, delay: 0.4, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
