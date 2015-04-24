//
//  Customer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class Customer : NSObject {
    public var address : Address?
    public var cards : [Card]?
    public var defaultCard : Int64?
    public var _description : String?
    public var dateCreated : NSDate?
    public var dateLastUpdated : NSDate?
    public var email : String?
    public var firstName : String?
    public var id : String?
    public var identification : Identification?
    public var lastName : String?
    public var liveMode : Bool?
    public var metadata : NSDictionary?
    public var phone : Phone?
    public var registrationDate : NSDate?
    
    public class func fromJSON(json : NSDictionary) -> Customer {
        var customer : Customer = Customer()
        customer.id = json["id"] as! String!
        customer.liveMode = json["live_mode"] as? Bool!
        customer.email = json["email"] as? String!
        customer.firstName = json["first_name"] as? String!
        customer.lastName = json["last_name"] as? String!
        customer._description = json["description"] as? String!
        customer.defaultCard = (json["default_card"] as? NSNumber)?.longLongValue
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
        customer.dateCreated = Utils.getDateFromString(json["date_created"] as? String)
        customer.dateLastUpdated = Utils.getDateFromString(json["date_last_updated"] as? String)
        customer.registrationDate = Utils.getDateFromString(json["date_registered"] as? String)
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
}