//
//  Bin.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Bin {
    var exclusionPattern : String!
    var installmentsPattern : String!
    var pattern : String!
    
    init() {}
    
    class func fromJSON(json : NSDictionary) -> Bin {
        var bin : Bin = Bin()
        bin.exclusionPattern = JSON(json["exclusion_pattern"]!).asString
        bin.installmentsPattern = JSON(json["installments_pattern"]!).asString
        bin.pattern = JSON(json["pattern"]!).asString
        return bin
    }
}