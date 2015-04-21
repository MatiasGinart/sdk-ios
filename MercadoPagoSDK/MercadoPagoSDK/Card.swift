//
//  Card.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class Card : NSObject {
    
    public var cardHolder : Cardholder?
    public var customerId : String?
    public var dateCreated : NSDate?
    public var dateLastUpdated : NSDate?
    public var expirationMonth : Int?
    public var expirationYear : Int?
    public var firstSixDigits : String?
    public var id : Int64?
    public var lastFourDigits : String?
    public var paymentMethod : PaymentMethod?
    public var issuer : Issuer?
    public var securityCode : SecurityCode?
    
    public override init() {
                super.init()
    }
    
   public class func fromJSON(json : NSDictionary) -> Card {
        var card : Card = Card()
        if json["customer_id"] != nil {
            card.customerId = JSON(json["customer_id"]!).asString
        }
        card.expirationMonth = JSON(json["expiration_month"]!).asInt
        card.expirationYear = JSON(json["expiration_year"]!).asInt
        card.id = (json["id"] as? NSNumber)?.longLongValue
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
        card.dateLastUpdated = Utils.getDateFromString(json["date_last_updated"] as? String)
        card.dateCreated = Utils.getDateFromString(json["date_created"] as? String)
        return card
    }
    
    public func isSecurityCodeRequired() -> Bool {
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