//
//  TimeViewController.swift
//  ALWekala
//
//  Created by Mac on 10/23/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {

   
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var nightLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nightCheckBox: UIButton!
    @IBOutlet weak var dayCheckbox: UIButton!
    @IBOutlet weak var setTime: UILabel!
    var dayFlag = false
    var nightFlag = false
    var nightTime  = ""
    var dayTime = ""
    var cartData :CartData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius  = 10
       self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let lang = UserDefaults.standard.value(forKey: "lang") as! String
        if lang == "ar" {
            setTime.text = "اختار وقت"
            contentView.semanticContentAttribute = .forceRightToLeft
            setTime.textAlignment = .right
            dayLabel.textAlignment = .right
            nightLabel.textAlignment = .right
        }
         let time = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = NSLocale.init(localeIdentifier: "en") as Locale
        let timeStr = formatter.string(from: time)
        print("timeNow\(timeStr)")
        
        print("tommorripowIs \(Date().tomorrow)")
        let timeArray  = timeStr.components(separatedBy: ":")
        let hour = Int(timeArray[0])
        if hour! >= 17  && hour! < 24 {
            print("betweeen + 1day\(Date().tomorrow) ")
            //"dd-MM-yyyy"
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "dd-MM-yyyy"
            var date = dayformatter.string(from: Date().tomorrow)
            if lang == "ar" {
                dayformatter.locale = NSLocale(localeIdentifier: "ar") as Locale?
                  dayformatter.dateFormat = "dd-MM-yyyy"
                date = dayformatter.string(from: Date().tomorrow)
                dayLabel.text = "timed".localized(lang: "ar") + "\(date)"
                nightLabel.text = "timeN".localized(lang: "ar") + " \(date)"
            }else{
                dayformatter.locale = NSLocale(localeIdentifier: "en") as Locale?
                date = dayformatter.string(from: Date().tomorrow)
                dayLabel.text = "day from 12pm -> 3 pm \(date)"
                nightLabel.text = "night from 6 pm -> 9 pm  \(date)"
            }
           
        }
        if hour! == 24 || hour! == 0 {
            //sameday
            print("same day")
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "dd-MM-yyyy"
            var date = dayformatter.string(from: Date())
              if lang == "ar" {
                dayformatter.locale = NSLocale(localeIdentifier: "ar") as Locale?
                date = dayformatter.string(from: Date())
                dayLabel.text = "timed".localized(lang: "ar") + " \(date) "
                nightLabel.text = "timeN".localized(lang: "ar") + " \(date) "
              }else{
                dayformatter.locale = NSLocale(localeIdentifier: "en") as Locale?
                date = dayformatter.string(from: Date())
                dayLabel.text = "day from 12 pm -> 3 pm \(date)"
                nightLabel.text = "night from 6pm -> 9 pm  \(date)"
            }
          
        }
        if hour! >= 1 && hour! < 11 {
            print("same day ")
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "dd-MM-yyyy"
            var date = dayformatter.string(from: Date())
            if lang == "ar" {
                dayformatter.locale = NSLocale(localeIdentifier: "ar") as Locale?
                dayformatter.dateFormat = "dd-MM-yyyy"
                date = dayformatter.string(from: Date())
                dayLabel.text = "timed".localized(lang: "ar") + " \(date) "
                nightLabel.text = "timeN".localized(lang: "ar") + " \(date) "
            }else{
                dayformatter.locale = NSLocale(localeIdentifier: "en") as Locale?
                date = dayformatter.string(from: Date())
                dayLabel.text = "day from 12 pm -> 3 pm \(date)"
                nightLabel.text = "night from 6 pm -> 9 pm  \(date)"
            }
            
        }
        if hour! >= 11 && hour! < 17 {
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "dd-MM-yyyy"
            var date = dayformatter.string(from: Date())
           if lang == "ar" {
            dayformatter.locale = NSLocale(localeIdentifier: "ar") as Locale?
            dayformatter.dateFormat = "dd-MM-yyyy"
               date = dayformatter.string(from: Date())
              nightLabel.text =  "timeN".localized(lang: "ar") + " \(date) "
              print("night same\(Date())")
              date = dayformatter.string(from: Date().tomorrow)
              print("day +1day\(Date().tomorrow)")
             dayLabel.text = "timed".localized(lang: "ar") + " \(date) " 
           }else{
            dayformatter.locale = NSLocale(localeIdentifier: "en") as Locale?
            date = dayformatter.string(from: Date())
            nightLabel.text = "night from 6 pm -> 9 pm \(date)"
            print("night same\(Date())")
            date = dayformatter.string(from: Date().tomorrow)
            print("day +1day\(Date().tomorrow)")
            dayLabel.text = "day from 12 pm -> 3 pm \(date)"
            }
        }
      

        
        
        
        
        
        
        
//        let calendar = Calendar.current
//
//        let startTimeComponent = DateComponents(calendar: calendar, hour: 17)
//        let endTimeComponent   = DateComponents(calendar: calendar, hour: 0)
//
//        let now = Date()
//        let startOfToday = calendar.startOfDay(for: now)
//        let startTime    = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
//        let endTime      = calendar.date(byAdding: endTimeComponent, to: startOfToday)!
//        print("endtime\(endTime)")
//        print(now)
//        if startTime <= now && now <= endTime {
//            print("between 5 AM and 0PM")
//        } else {
//            print("not between 5 AM and 0 PM")
//        }
//
        // Do any additional setup after loading the view.
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

    @IBAction func nightBtnCheckBoxAction(_ sender: Any) {
        nightFlag = !nightFlag
        if nightFlag == true {
            nightCheckBox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
            dayCheckbox.setImage(UIImage(named: "radioGray.png"), for: .normal)
            dayFlag = false
        }else{
            nightCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
        }
    }
    @IBAction func dayCheckboxBtnAction(_ sender: Any) {
        dayFlag = !dayFlag
        if dayFlag == true {
             dayCheckbox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
            nightCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
           nightFlag = false
        }else{
             dayCheckbox.setImage(UIImage(named: "radioGray.png"), for: .normal)
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func okBtnAction(_ sender: Any) {
        var selectedTime = ""
        var day = 0
        if  nightFlag == true || dayFlag == true {
            if nightFlag == true {
              selectedTime = nightLabel.text!
                day = 2
          }
            if dayFlag == true {
                selectedTime = dayLabel.text!
                day = 1
            }
            cartData?.time = selectedTime
            cartData?.day = day 
             self.view.removeFromSuperview()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            vc.cartData = cartData
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
               let lang = UserDefaults.standard.value(forKey: "lang") as! String
            if lang == "ar" {
                let alert = UIAlertController(title: "", message: "اختار الوقت", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "set time", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}
extension Date {
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
}
}
