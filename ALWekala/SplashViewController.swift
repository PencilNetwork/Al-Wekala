//
//  SplashViewController.swift
//  WekalaDelivery
//
//  Created by Mac on 10/15/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var topImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var heightImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var vegWidthImgConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vegImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
         topImageHeight.constant = 0
        heightImageConstraint.constant = self.view.frame.height * 0.2
        vegWidthImgConstraint.constant = 0.7 * self.view.frame.width
            self.navigationController?.isNavigationBarHidden = true
       
        // Do any additional setup after loading the view.
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
 self.navigationController?.isNavigationBarHidden = true
         // perform(#selector(showNavigation),with:nil,afterDelay:2)
        if UserDefaults.standard.value(forKey: "logout") as? Bool == true {
            performSegue(withIdentifier: "showNavigation", sender: self)
        }else{
            perform(#selector(showNavigation),with:nil,afterDelay:2)
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: Double(2), animations: {
            self.topImageHeight.constant = (self.view.bounds.height/2)  - (self.vegImg.bounds.height/2)
            self.view.layoutIfNeeded()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 @objc func showNavigation(){
    
    if UserDefaults.standard.value(forKey: "Login") as? Bool == true {
         if UserDefaults.standard.value(forKey: "LoginEnter") as? Bool == false || UserDefaults.standard.value(forKey: "LoginEnter")  == nil {//logout
          performSegue(withIdentifier: "showNavigation", sender: self)
         }else{
                   let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MakeOrderViewController") as! MakeOrderViewController
         
                   self.navigationController?.pushViewController(viewController, animated: true)
         }
   
      
    }else{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        
        self.present(newViewController, animated: false, completion: nil)
    }
    }
}
