//
//  IdentificationType.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 2/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class IdentificationType {
    var id : String?
    var name : String?
    var type : String?
    var minLength : Int?
    var maxLength : Int?
    
    class func fromJSON(json : NSDictionary) -> IdentificationType {
        var identificationType : IdentificationType = IdentificationType()
        identificationType.id = JSON(json["id"]!).asString
        identificationType.name = JSON(json["name"]!).asString
        identificationType.type = JSON(json["type"]!).asString
        identificationType.minLength = (json["min_length"]! as Int)
        identificationType.maxLength = (json["max_length"]! as Int)
        return identificationType
    }
}