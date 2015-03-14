//
//  Item.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class Item {
    var id : String!
    var quantity : Int!
    var unitPrice : Double!

    init() {}
    
    init(id: String, quantity: Int, unitPrice: Double) {
        self.id = id
        self.quantity = quantity
        self.unitPrice = unitPrice
    }
    
    func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "id": self.id!,
            "quantity" : self.quantity!,
            "unit_price" : self.unitPrice!
        ]
        return JSON(obj).toString()
    }
}