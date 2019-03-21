//
//  ViewController.swift
//  ALWekala
//
//  Created by Mac on 10/21/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SDWebImage
import FBSDKLoginKit
import Alamofire
import FBSDKCoreKit
class ViewController: UIViewController ,GIDSignInUIDelegate{
    
    @IBOutlet weak var facebookLbl: UILabel!
    @IBOutlet weak var googleLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var facebookImg: UIImageView!
    @IBOutlet weak var googleImg: UIImageView!
    @IBOutlet weak var languageLBL: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var cartImg: UIImageView!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var languageBtn: UIButton!
     @IBOutlet weak var contentView: UIView!
    var email:String?
    var name:String?
    var id:String?
    var flag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        langView.layer.cornerRadius = 10
        langView.layer.borderWidth = 0.5
       imageWidth.constant = self.view.frame.width/2
        imageHeight.constant = self.view.frame.width/2
         GIDSignIn.sharedInstance().uiDelegate = self
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        NotificationCenter.default.addObserver(self, selector: #selector(putImage(_:)), name: NSNotification.Name(rawValue: "putName"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(deleteActivityIndicator(_:)), name: NSNotification.Name(rawValue: "deleteActivityIndi"), object: nil)
//        facebookBtn.layer.cornerRadius = 10
//        googleBtn.layer.cornerRadius = 10
         UserDefaults.standard.set("en", forKey: "lang")
        languageLBL.textAlignment = .left
        UserDefaults.standard.set(false,forKey: "logout")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        languageBtn.layer.cornerRadius = 20
        facebookBtn.layer.cornerRadius = 25
        googleBtn.layer.cornerRadius = 25
        let lang =  UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar"{
//            googleLbl.textAlignment = .right
//            facebookLbl.textAlignment = .right
        }else{
            contentView.semanticContentAttribute = .forceLeftToRight
//            googleLbl.textAlignment = .left
//            facebookLbl.textAlignment = .left
        }
        if flag == true {
            self.continueBtn.isHidden = true
            self.profileImg.isHidden = true
            self.cartImg.isHidden = false
            self.googleBtn.isHidden = false
            self.facebookBtn.isHidden = false
            self.lineView.isHidden = true
            self.nameView.isHidden = true
            self.languageBtn.isHidden = false
            self.downArrow.isHidden = false
            flag = false
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
      @objc func deleteActivityIndicator(_ notification: NSNotification){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    @objc func putImage(_ notification: NSNotification){
        profileImg.isHidden = false
        nameView.isHidden = false
        lineView.isHidden = false
        googleBtn.isHidden = true
        facebookBtn.isHidden = true
        continueBtn.isHidden = false
            self.cartImg.isHidden = true
        languageBtn.isHidden = true
        languageLBL.isHidden = true
         self.downArrow.isHidden = true
        facebookImg.isHidden = true
        googleImg.isHidden = true
       googleLbl.isHidden = true
       facebookLbl.isHidden = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        if let dict = notification.userInfo as NSDictionary? {
            if let image = dict["image"] as? URL{
                self.profileImg.sd_setImage(with: image, placeholderImage: UIImage(named: "profile.jpg"))
                // do something with your image
            }
            if let name = dict["name"] as? String{
                nameLBL.text = name
                self.name = name
            }
            if let email = dict["email"] as? String{
                self.email = email
            }
            if let id = dict["id"] as? String{
                self.id = id
            }
            try GIDSignIn.sharedInstance().signOut()
        }
    }
    @IBAction func LanguageBtnAction(_ sender: Any) {
        langView.isHidden = !langView.isHidden
    }
    
    @IBAction func englishBtnAction(_ sender: Any) {
        langView.isHidden =  true
//        googleLbl.textAlignment = .left
//        facebookLbl.textAlignment = .left
        contentView.semanticContentAttribute = .forceLeftToRight
        languageBtn.contentHorizontalAlignment = .left
//        languageBtn.setTitle("English", for: .normal)
        languageLBL.text = "English"
        languageLBL.textAlignment = .left
        UserDefaults.standard.set("en", forKey: "lang")
        // facebookBtn.setTitle("Login with Facebook", for: .normal)
        facebookLbl.text = "Login with Facebook"
        googleLbl.text = "Login with Google"
//        googleBtn.setTitle("Login with Google", for: .normal)
          continueBtn.setTitle("Continue", for: .normal)
    }
    
    @IBAction func arabicBtnAction(_ sender: Any) {
        langView.isHidden = true
//        googleLbl.textAlignment = .right
//        facebookLbl.textAlignment = .right
        languageBtn.contentHorizontalAlignment = .right
        contentView.semanticContentAttribute = .forceRightToLeft
        //languageBtn.setTitle("Arabic", for: .normal)
        languageLBL.text = "Arabic"
        languageLBL.textAlignment = .right
        UserDefaults.standard.set("ar", forKey: "lang")
        //facebookBtn.setTitle(" تسجيل الدخول ب Facebook", for: .normal)
        facebookLbl.text = "تسجيل الدخول بالفيسبوك"
         googleLbl.text = "تسجيل الدخول بجوجل "
        //googleBtn.setTitle(" ب تسجيل الدخول google", for: .normal)
       continueBtn.setTitle("استمر", for: .normal)
    }

    @IBAction func facebookBtnAction(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                 self.activityIndicator.isHidden = true
                  self.activityIndicator.stopAnimating()
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            print("social token \(accessToken.tokenString)")
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                let _ = request?.start(completionHandler: { (connection, result, error) in
                    guard let userInfo = result as? [String: Any] else { return } //handle the error
                    
                    //The url is nested 3 layers deep into the result so it's pretty messy
                    if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.continueBtn.isHidden = false
                        self.profileImg.isHidden = false
                        self.cartImg.isHidden = true
                        self.googleBtn.isHidden = true
                        self.facebookBtn.isHidden = true
                        self.lineView.isHidden = false
                        self.nameView.isHidden = false
                         self.languageBtn.isHidden = true
                        self.downArrow.isHidden = true
                        self.facebookImg.isHidden = true
                        self.googleImg.isHidden = true
                        self.googleLbl.isHidden = true
                        self.facebookLbl.isHidden = true
                        self.profileImg.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "profile.jpg"))
                        
                        
                        
                    }
                    if let name = userInfo["name"] as? String {
                        self.nameLBL.text = name
                        self.name = name
                        
                        if let id  = userInfo["id"] as? String{
                            print("id\(id)")
                            self.id = id
                            
                            if let email = userInfo["email"] as? String {
                                self.email = email
                            }
                            
                            
                            
                        }
                    }
                   
                    
                    
                    
                    FBSDKLoginManager().logOut()
                    FBSDKAccessToken.setCurrent(nil)
                    FBSDKProfile.setCurrent(nil)
                    //      FBSDKLoginManager().logOut()
                    
                })
                
                
            })
            
        }
        
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var lang =  UserDefaults.standard.value(forKey: "lang") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
       UserDefaults.standard.set(id!, forKey: "socialId")
        parameter["social_id"] = id! as AnyObject?
        parameter["language"] = lang   as AnyObject?
        parameter["token"] = "token" as  AnyObject?
        let url = Constant.baseUrl + Constant.loginUrl
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let flag = datares["flag"] as? String {
                            if flag == "0" { //new user
                                
                              //signup
                                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                if let customer = datares["customer"] as? [String:Any]{
                                       UserDefaults.standard.set(true, forKey: "LoginEnter")
                                    if let id = customer["id"] as? Int {
                                        var person = Person(id:"\(id)",name:customer["name"] as! String ,token: customer["token"] as! String,phone:customer["phone"] as! String,address:customer["address"] as! String,flat_number:customer["flat_number"] as! String,social_id:customer["social_id"] as! String,long:customer["langitude"] as! String ,lat:customer["latitude"] as! String,city:customer["city"] as! String,regoin:customer["regoin"] as! String,besides:customer["besides"] as! String,created_at:customer["created_at"] as! String,updated_at:customer["updated_at"] as! String)
                                        let encodeData =  NSKeyedArchiver.archivedData(withRootObject: person)
                                        UserDefaults.standard.set(encodeData, forKey: "person")
                                        if let data = UserDefaults.standard.data(forKey: "person"){
                                            let person = NSKeyedUnarchiver.unarchiveObject(with: data) as? Person
                                            print("ewrw person\(person?.name)")
                                        }
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeOrderViewController") as! MakeOrderViewController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
//                                    if let name = customer["name"] as? String {
//
//                                    }
//                                    if let token = customer["token"] as? String {
//
//                                    }
//                                    if let phone = customer["phone"] as? String {
//
//                                    }
//                                    if let address = customer["address"] as? String {
//
//                                    }
//                                    if let flat_number = customer["flat_number"] as? String {
//
//                                    }
//                                    if let social_id = customer["social_id"] as? String {
//
//                                    }
//                                    if let langitude = customer["langitude"] as? String {
//
//                                    }
//                                    if let latitude = customer["latitude"] as? String {
//
//                                    }
//                                    if let city = customer["city"] as? String {
//
//                                    }
//                                    if let regoin = customer["regoin"] as? String {
//
//                                    }
//                                    if let besides = customer["besides"] as? String {
//
//                                    }
//                                    if let created_at = customer["created_at"] as? String{
//
//                                    }
//                                    if let updated_at = customer["updated_at"] as? String {
//
//                                    }
                                }
                                
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
    
    @IBAction func googleBtnAction(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        GIDSignIn.sharedInstance().signIn()
    }
    
    
}
extension String {
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}
}
