//
//  Refund.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Refund : NSObject {
    public var amount : Double!
    public var dateCreated : NSDate!
    public var id : Int!
    public var metadata : NSObject!
    public var paymentId : Int!
    public var source : String!
    public var uniqueSequenceNumber : String!
    
    public class func fromJSON(json : NSDictionary) -> Refund {
        var refund : Refund = Refund()
        refund.id = json["id"] as Int!
        refund.source = JSON(json["source"]!).asString
        refund.uniqueSequenceNumber = JSON(json["unique_sequence_number"]!).asString
        refund.paymentId = json["payment_id"] as Int!
        refund.dateCreated = Utils.getDateFromString(json["date_created"] as String!)
        return refund
    }
    
}
