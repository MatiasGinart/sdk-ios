//
//  SecurityCode.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class SecurityCode : Serializable {
    public var length : Int = 0
    public var cardLocation : String!
    public var mode : String!
    
    public class func fromJSON(json : NSDictionary) -> SecurityCode {
        var securityCode : SecurityCode = SecurityCode()
        if json["length"] != nil && !(json["length"]! is NSNull) {
            securityCode.length = (json["length"]! as? Int)!
        }
        if json["card_location"] != nil && !(json["card_location"]! is NSNull) {
            securityCode.cardLocation = JSON(json["card_location"]!).asString
        }
        if json["mode"] != nil && !(json["mode"]! is NSNull) {
            securityCode.mode = JSON(json["mode"]!).asString
        }
        return securityCode
    }
}