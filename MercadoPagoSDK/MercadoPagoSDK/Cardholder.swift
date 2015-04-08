//
//  Cardholder.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Cardholder : NSObject {
    public var name : String?
    public var identification : Identification?
    
    public override init () {
                super.init()
    }
    
    public class func fromJSON(json : NSDictionary) -> Cardholder {
        var cardholder : Cardholder = Cardholder()
        cardholder.name = JSON(json["name"]!).asString
        cardholder.identification = Identification.fromJSON(json["identification"]! as NSDictionary)
        return cardholder
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "name": String.isNullOrEmpty(self.name) ? JSON.null : self.name!,
            "identification" : self.identification == nil ? JSON.null : JSON.parse(self.identification!.toJSONString()).mutableCopyOfTheObject()
        ]
        return JSON(obj).toString()
    }
}