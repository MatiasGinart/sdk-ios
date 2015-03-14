//
//  Card.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    var cardHolder : Cardholder?
    var customerId : String?
    var dateCreated : NSDate?
    var dateLastUpdated : NSDate?
    var expirationMonth : Int?
    var expirationYear : Int?
    var firstSixDigits : String?
    var id : Int64?
    var lastFourDigits : String?
    var paymentMethod : PaymentMethod?
    var issuer : Issuer?
    var securityCode : SecurityCode?
    
    init() {
        
    }
    
   class func fromJSON(json : NSDictionary) -> Card {
        var card : Card = Card()
        if json["customer_id"] != nil {
            card.customerId = JSON(json["customer_id"]!).asString
        }
        card.expirationMonth = JSON(json["expiration_month"]!).asInt
        card.expirationYear = JSON(json["expiration_year"]!).asInt
        card.id = Int64((json["id"]! as Int))
        card.lastFourDigits = JSON(json["last_four_digits"]!).asString
        card.firstSixDigits = JSON(json["first_six_digits"]!).asString
        if let issuerDic = json["issuer"] as? NSDictionary {
            card.issuer = Issuer.fromJSON(issuerDic)
        }
        if let secDic = json["security_code"] as? NSDictionary {
            card.securityCode = SecurityCode.fromJSON(secDic)
        }
        if let pmDic = json["payment_method"] as? NSDictionary {
            card.paymentMethod = PaymentMethod.fromJSON(pmDic)
        }
        if let chDic = json["cardholder"] as? NSDictionary {
            card.cardHolder = Cardholder.fromJSON(chDic)
        }
        card.dateLastUpdated = JSON(json["date_last_updated"]!).asDate
        card.dateCreated = JSON(json["date_created"]!).asDate
        return card
    }
    
    func isSecurityCodeRequired() -> Bool {
        if securityCode != nil {
            if securityCode!.length != 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}