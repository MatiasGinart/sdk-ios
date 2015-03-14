//
//  CardNumber.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class CardNumber {
    var length : Int!
    var validation : String!
    
    init() {}
    
    class func fromJSON(json : NSDictionary) -> CardNumber {
        var cardNumber : CardNumber = CardNumber()
        cardNumber.validation = JSON(json["validation"]!).asString
        cardNumber.length = JSON(json["length"]!).asInt
        return cardNumber
    }
    
}