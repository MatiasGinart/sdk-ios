//
//  Issuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Issuer : NSObject {
    public var _id : Int64?
    public var name : String?
    
    public class func fromJSON(json : NSDictionary) -> Issuer {
        var issuer : Issuer = Issuer()
        if json["id"] != nil && !(json["id"]! is NSNull) {
            issuer._id = (json["id"]! as? NSString)?.longLongValue
        }
        issuer.name = JSON(json["name"]!).asString
        return issuer
    }
}