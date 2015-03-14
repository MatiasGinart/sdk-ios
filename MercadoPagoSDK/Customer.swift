//
//  Customer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class Customer {
    var address : Address?
    var cards : [Card]?
    var defaultCard : Int64?
    var description : String?
    var dateCreated : NSDate?
    var dateLastUpdated : NSDate?
    var email : String?
    var firstName : String?
    var id : String?
    var identification : Identification?
    var lastName : String?
    var liveMode : Bool?
    var metadata : NSDictionary?
    var phone : Phone?
    var registrationDate : NSDate?
    
    class func fromJSON(json : NSDictionary) -> Customer {
        var customer : Customer = Customer()
        customer.id = json["id"] as String!
        customer.liveMode = JSON(json["livemode"]!).asBool
        customer.email = JSON(json["email"]!).asString
        customer.firstName = JSON(json["first_name"]!).asString
        customer.lastName = JSON(json["last_name"]!).asString
        customer.description = JSON(json["description"]!).asString
        customer.defaultCard = Int64((json["default_card"]! as Int))
        if let identificationDic = json["identification"] as? NSDictionary {
            customer.identification = Identification.fromJSON(identificationDic)
        }
        if let phoneDic = json["phone"] as? NSDictionary {
            customer.phone = Phone.fromJSON(phoneDic)
        }
        if let addressDic = json["address"] as? NSDictionary {
            customer.address = Address.fromJSON(addressDic)
        }
        customer.metadata = json["metadata"]! as? NSDictionary
        customer.dateCreated = JSON(json["date_created"]!).asDate
        customer.dateLastUpdated = JSON(json["date_last_updated"]!).asDate
        customer.registrationDate = JSON(json["date_registered"]!).asDate
        var cards : [Card] = [Card]()
        if let cardsArray = json["cards"] as? NSArray {
            for i in 0..<cardsArray.count {
                if let cardDic = cardsArray[i] as? NSDictionary {
                    cards.append(Card.fromJSON(cardDic))
                }
            }
        }
        customer.cards = cards
        return customer
    }
    
    init(){
        
    }
}