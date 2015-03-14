//
//  Refund.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Refund {
    var amount : Double!
    var dateCreated : NSDate!
    var id : Int!
    var metadata : NSObject!
    var paymentId : Int!
    var source : String!
    var uniqueSequenceNumber : String!
    
    class func fromJSON(json : NSDictionary) -> Refund {
        var refund : Refund = Refund()
        refund.id = json["id"] as Int!
        refund.source = JSON(json["source"]!).asString
        refund.uniqueSequenceNumber = JSON(json["unique_sequence_number"]!).asString
        refund.paymentId = json["payment_id"] as Int!
        refund.dateCreated = JSON(json["date_created"]!).asDate
        return refund
    }
    
}
