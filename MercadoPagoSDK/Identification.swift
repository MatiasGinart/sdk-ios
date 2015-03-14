//
//  Identification.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class Identification {
    var type : String?
    var number : String?
    
    init () {
        
    }
    
    init (type: String?, number : String?) {
        self.type = type
        self.number = number
    }
    
    class func fromJSON(json : NSDictionary) -> Identification {
        var identification : Identification = Identification()
        identification.type = JSON(json["type"]!).asString
        identification.number = JSON(json["number"]!).asString
        return identification
    }
    
    func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "type": String.isNullOrEmpty(self.type) ? JSON.null : self.type!,
            "number": String.isNullOrEmpty(self.number) ? JSON.null : self.number!
        ]
        return JSON(obj).toString()
    }
}