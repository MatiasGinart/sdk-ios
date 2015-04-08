//
//  SecurityCode.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class SecurityCode : NSObject {
    public var length : Int!
    public var cardLocation : String!
    public var mode : String!
    
    public class func fromJSON(json : NSDictionary) -> SecurityCode {
        var securityCode : SecurityCode = SecurityCode()
        if json["length"] != nil {
            securityCode.length = JSON(json["length"]!).asInt
        }
        if json["card_location"] != nil {
            securityCode.cardLocation = JSON(json["card_location"]!).asString
        }
        if json["mode"] != nil {
            securityCode.mode = JSON(json["mode"]!).asString
        }
        return securityCode
    }
}