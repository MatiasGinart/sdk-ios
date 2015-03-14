//
//  Order.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Order {
    var id : Int!
    var type : String!
    
    class func fromJSON(json : NSDictionary) -> Order {
        var order : Order = Order()
        order.id = json["id"] as Int!
        order.type = json["type"] as String!
        return order
    }
}