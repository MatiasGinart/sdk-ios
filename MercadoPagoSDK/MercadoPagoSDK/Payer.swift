//
//  Payer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Payer {
    public var email : String!
    public var _id : Int64 = 0
    public var identification : Identification!
    public var type : String!
    
    public class func fromJSON(json : NSDictionary) -> Payer {
        var payer : Payer = Payer()
		if json["id"] != nil && !(json["id"]! is NSNull) {
			payer._id = (json["id"] as? NSString)!.longLongValue
		}
        payer.email = JSON(json["email"]!).asString
        payer.type = JSON(json["type"]!).asString
        if let identificationDic = json["identification"] as? NSDictionary {
            payer.identification = Identification.fromJSON(identificationDic)
        }
        return payer
    }
    
}