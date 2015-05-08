//
//  Item.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Item : NSObject {
    public var _id : String!
    public var quantity : Int = 0
    public var unitPrice : Double = 0
    
    public init(_id: String, quantity: Int, unitPrice: Double) {
        super.init()
        self._id = _id
        self.quantity = quantity
        self.unitPrice = unitPrice
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "id": self._id!,
            "quantity" : self.quantity,
            "unit_price" : self.unitPrice
        ]
        return JSON(obj).toString()
    }
}