//
//  Person.swift
//  ALWekala
//
//  Created by Mac on 10/21/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import Foundation
class Person: NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id,forKey:"id")
        aCoder.encode(self.name,forKey:"name")
        aCoder.encode(self.token,forKey:"token")
        aCoder.encode(self.phone,forKey:"phone")
        aCoder.encode(self.address ,forKey:"address")
        aCoder.encode(self.flat_number  ,forKey:"flat_number")
        aCoder.encode(self.social_id  ,forKey:"social_id")
        aCoder.encode(self.langitude  ,forKey:"langitude")
         aCoder.encode(self.latitude  ,forKey:"latitude")
        aCoder.encode(self.city  ,forKey:"city")
        aCoder.encode(self.regoin  ,forKey:"regoin")
        aCoder.encode(self.besides  ,forKey:"besides")
        aCoder.encode(self.created_at  ,forKey:"created_at")
        aCoder.encode(self.updated_at  ,forKey:"updated_at")
    }
    
    var id  = String()
    var name = String()
    var token = String()
    var phone = String()
    var address = String()
    var flat_number = String()
     var social_id = String()
    var langitude = String()
    var latitude = String()
    var city = String()
    var regoin = String()
    var besides = String()
    var created_at = String()
    var updated_at = String()
       init(id:String,name:String,token:String,phone:String,address:String,flat_number:String,social_id:String,long:String,lat:String,city:String,regoin:String,besides:String,created_at:String,updated_at:String){
          self.id = id
          self.name = name
          self.token = token
          self.phone = phone
          self.address = address
          self.flat_number = flat_number
          self.social_id = social_id
          self.langitude = long
          self.latitude = lat
          self.city = city
          self.regoin = regoin
          self.besides = besides
          self.created_at = created_at
          self.updated_at = updated_at
        
        
    }
    required init(coder aDecoder:NSCoder!){
         self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.id = aDecoder.decodeObject(forKey: "id") as! String
       
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.address = aDecoder.decodeObject(forKey: "address") as! String
        self.flat_number = aDecoder.decodeObject(forKey: "flat_number") as! String
        self.social_id = aDecoder.decodeObject(forKey: "social_id") as! String
        self.langitude = aDecoder.decodeObject(forKey: "langitude") as! String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.regoin =  aDecoder.decodeObject(forKey: "regoin") as! String
        self.besides = aDecoder.decodeObject(forKey: "besides") as! String
        self.created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        self.updated_at =  aDecoder.decodeObject(forKey: "updated_at") as! String
    }
    func initWithCoder(aDecoder: NSCoder) -> Person{
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.address = aDecoder.decodeObject(forKey: "address") as! String
        self.flat_number = aDecoder.decodeObject(forKey: "flat_number") as! String
        self.social_id = aDecoder.decodeObject(forKey: "social_id") as! String
        self.langitude = aDecoder.decodeObject(forKey: "langitude") as! String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.regoin =  aDecoder.decodeObject(forKey: "regoin") as! String
        self.besides = aDecoder.decodeObject(forKey: "besides") as! String
        self.created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        self.updated_at =  aDecoder.decodeObject(forKey: "updated_at") as! String
        return self
    }
//    func encodeWithCoder(aCoder:NSCoder!){
//         aCoder.encode(self.id,forKey:"id")
//        aCoder.encode(self.name,forKey:"name")
//         aCoder.encode(self.token,forKey:"token")
//         aCoder.encode(self.phone,forKey:"phone")
//         aCoder.encode(self.address ,forKey:"address")
//         aCoder.encode(self.flat_number  ,forKey:"flat_number")
//        aCoder.encode(self.social_id  ,forKey:"social_id")
//        aCoder.encode(self.langitude  ,forKey:"langitude")
//         aCoder.encode(self.city  ,forKey:"city")
//         aCoder.encode(self.regoin  ,forKey:"regoin")
//        aCoder.encode(self.besides  ,forKey:"besides")
//        aCoder.encode(self.created_at  ,forKey:"created_at")
//         aCoder.encode(self.updated_at  ,forKey:"updated_at")
//    }
}
