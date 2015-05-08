//
//  FeesDetail.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class FeesDetail : NSObject {
    public var amount : Double = 0
    public var amountRefunded : Double = 0
    public var feePayer : String!
    public var type : String!
    
    public class func fromJSON(json : NSDictionary) -> FeesDetail {
        var fd : FeesDetail = FeesDetail()
        fd.type = JSON(json["type"]!).asString
        fd.feePayer = JSON(json["fee_payer"]!).asString
		if json["amount"] != nil && !(json["amount"]! is NSNull) {
			fd.amount = JSON(json["amount"]!).asDouble!
		}
        if json["amount_refunded"] != nil && !(json["amount_refunded"]! is NSNull) {
            fd.amountRefunded = JSON(json["amount_refunded"]!).asDouble!
        }
        return fd
    }
    
}