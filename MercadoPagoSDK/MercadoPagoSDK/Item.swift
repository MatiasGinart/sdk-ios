//
//  Item.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Item : NSObject {
    public var id : String!
    public var quantity : Int!
    public var unitPrice : Double!
    
    public init(id: String, quantity: Int, unitPrice: Double) {
        super.init()
        self.id = id
        self.quantity = quantity
        self.unitPrice = unitPrice
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "id": self.id!,
            "quantity" : self.quantity!,
            "unit_price" : self.unitPrice!
        ]
        return JSON(obj).toString()
    }
}