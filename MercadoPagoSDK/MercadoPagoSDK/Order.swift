//
//  Order.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Order : NSObject {
    public var _id : Int = 0
    public var type : String!
    
    public class func fromJSON(json : NSDictionary) -> Order {
        var order : Order = Order()
		if json["id"] != nil && !(json["id"]! is NSNull) {
			order._id = (json["id"] as? Int)!
		}
        order.type = json["type"] as? String
        return order
    }
}