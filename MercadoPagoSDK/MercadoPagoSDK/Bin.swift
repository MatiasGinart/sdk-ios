//
//  Bin.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Bin : NSObject {
    public var exclusionPattern : String!
    public var installmentsPattern : String!
    public var pattern : String!
    
    public override init() {
            super.init()
    }
    
    public class func fromJSON(json : NSDictionary) -> Bin {
        var bin : Bin = Bin()
        bin.exclusionPattern = JSON(json["exclusion_pattern"]!).asString
        bin.installmentsPattern = JSON(json["installments_pattern"]!).asString
        bin.pattern = JSON(json["pattern"]!).asString
        return bin
    }
}