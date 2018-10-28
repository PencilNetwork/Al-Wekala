//
//  UserLeftMenuVC.swift
//  BusinessBook
//
//  Created by Mac on 10/1/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
protocol menuDelegate{
    func menuActionDelegate(number:Int)
}
class UserLeftMenuVC: UIViewController,menuDelegate {
 var menu_vc:UserMenuViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = false
          menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "UserMenuViewController") as! UserMenuViewController
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"menu.png"), for: .normal)
        menuBtn.addTarget(self, action: #selector(MenuButtonTapped), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        if #available(iOS 9.0, *) {
            let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 9.0, *) {
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeOrderViewController") as! MakeOrderViewController
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
            self.menu_vc.view.frame = CGRect(x:0,y:60,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
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
                 self.navigationItem.title = "home".localized(lang: "ar")
            }else{
             self.navigationItem.title = "Home"
            }
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//            self.addChildViewController(vc)
//            self.view.addSubview(vc.view)
        case 1:
            print("confirmed order")
            if lang == "ar" {
                self.navigationItem.title = "confirmOrder".localized(lang: "ar")
            }else{
                  self.navigationItem.title = "Confirm Order"
            }
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmedOrdersViewController") as! ConfirmedOrdersViewController
//            self.addChildViewController(vc)
//            self.view.addSubview(vc.view)
        case 2:
            print("")
            if lang == "ar" {
                self.navigationItem.title = "cancelOrder".localized(lang: "ar")
            }else{
                 self.navigationItem.title = "Cancel Order"
            }
           
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelOrdersViewController") as! CancelOrdersViewController
//
//            self.addChildViewController(vc)
//            self.view.addSubview(vc.view)
      
        default:
            print("")
            
        }
    }
    

}
