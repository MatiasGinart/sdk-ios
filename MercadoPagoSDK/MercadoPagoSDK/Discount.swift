//
//  Discount.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Discount : NSObject {
    public var amountOff : Int64!
    public var couponAmount : Int64!
    public var currencyId : String!
    public var id : Int!
    public var name : String!
    public var percentOff : Int64!
    
    public class func fromJSON(json : NSDictionary) -> Discount {
        var discount : Discount = Discount()
        discount.amountOff = (json["amount_off"] as? NSNumber)?.longLongValue
        discount.couponAmount = (json["coupon_amount"] as? NSNumber)?.longLongValue
        discount.currencyId = JSON(json["currency_id"]!).asString
        discount.id = json["id"]! as? Int
        discount.name = JSON(json["name"]!).asString
        discount.percentOff = (json["percent_off"] as? NSNumber)?.longLongValue
        return discount
    }
}