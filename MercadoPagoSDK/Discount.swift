//
//  Discount.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Discount {
    var amountOff : Int64!
    var couponAmount : Int64!
    var currencyId : String!
    var id : Int!
    var name : String!
    var percentOff : Int64!
    
    // TODO: ParseJSON
    class func fromJSON(json : NSDictionary) -> Discount {
        var discount : Discount = Discount()
        discount.amountOff = Int64((json["amount_off"]! as Int))
        discount.couponAmount = Int64((json["coupon_amount"]! as Int))
        discount.currencyId = JSON(json["currency_id"]!).asString
        discount.id = json["id"]! as Int
        discount.name = JSON(json["name"]!).asString
        discount.percentOff = Int64((json["percent_off"]! as Int))
        return discount
    }
}