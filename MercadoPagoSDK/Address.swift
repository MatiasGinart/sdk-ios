//
//  Address.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class Address {
    var streetName : String?
    var streetNumber : Int64?
    var zipCode : String?
    
    init () {
        
    }
    
    init (streetName: String?, streetNumber: Int64?, zipCode : String?) {
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.zipCode = zipCode
    }
    
    class func fromJSON(json : NSDictionary) -> Address {
        var address : Address = Address()
        address.streetName = JSON(json["street_name"]!).asString
        if json["street_number"] != nil {
//            address.streetNumber = Int64(json["street_number"]! as Int)
        }
        address.zipCode = JSON(json["zip_code"]!).asString
        return address
    }
}