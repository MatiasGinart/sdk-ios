//
//  Payer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Payer {
    var email : String!
    var id : Int64!
    var identification : Identification!
    var type : String!
    
    class func fromJSON(json : NSDictionary) -> Payer {
        var payer : Payer = Payer()
        payer.id = (json["id"] as NSString).longLongValue
        payer.email = JSON(json["email"]!).asString
        payer.type = JSON(json["type"]!).asString
        if let identificationDic = json["identification"] as? NSDictionary {
            payer.identification = Identification.fromJSON(identificationDic)
        }
        return payer
    }
    
}