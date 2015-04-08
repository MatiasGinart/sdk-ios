//
//  Identification.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Identification : NSObject {
    public var type : String?
    public var number : String?
    
    public override init() {
        super.init()
    }
    
    public init (type: String?, number : String?) {
        super.init()
        self.type = type
        self.number = number
    }
    
    public class func fromJSON(json : NSDictionary) -> Identification {
        var identification : Identification = Identification()
        identification.type = JSON(json["type"]!).asString
        identification.number = JSON(json["number"]!).asString
        return identification
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "type": String.isNullOrEmpty(self.type) ? JSON.null : self.type!,
            "number": String.isNullOrEmpty(self.number) ? JSON.null : self.number!
        ]
        return JSON(obj).toString()
    }
}