//
//  Issuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class Issuer {
    var id : Int?
    var name : String?
    
    init() {}
    
    class func fromJSON(json : NSDictionary) -> Issuer {
        var issuer : Issuer = Issuer()
        if json["id"] != nil {
            issuer.id = json["id"]!.integerValue
        }
        issuer.name = JSON(json["name"]!).asString
        return issuer
    }
}