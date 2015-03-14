//
//  Phone.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class Phone {
    var areaCode : String?
    var number : String?
    
    init() {}
    
    class func fromJSON(json : NSDictionary) -> Phone {
        var phone : Phone = Phone()
        phone.areaCode = JSON(json["area_code"]!).asString
        phone.number = JSON(json["number"]!).asString
        return phone
    }
}