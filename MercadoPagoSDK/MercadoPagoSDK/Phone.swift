//
//  Phone.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Phone : NSObject {
    public var areaCode : String?
    public var number : String?
    
    public class func fromJSON(json : NSDictionary) -> Phone {
        var phone : Phone = Phone()
        phone.areaCode = JSON(json["area_code"]!).asString
        phone.number = JSON(json["number"]!).asString
        return phone
    }
}