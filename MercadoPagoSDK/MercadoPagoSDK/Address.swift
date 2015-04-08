//
//  Address.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Address : NSObject {
    public var streetName : String?
    public var streetNumber : Int64?
    public var zipCode : String?
    
    public override init () {
                super.init()
    }
    
    public init (streetName: String?, streetNumber: Int64?, zipCode : String?) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.zipCode = zipCode
    }
    
    public class func fromJSON(json : NSDictionary) -> Address {
        var address : Address = Address()
        address.streetName = JSON(json["street_name"]!).asString
        if json["street_number"] != nil {
            address.streetNumber = (json["street_number"] as? NSNumber)?.longLongValue
        }
        address.zipCode = JSON(json["zip_code"]!).asString
        return address
    }
}