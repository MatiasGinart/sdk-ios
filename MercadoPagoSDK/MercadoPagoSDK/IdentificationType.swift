//
//  IdentificationType.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 2/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class IdentificationType : NSObject {
    public var id : String?
    public var name : String?
    public var type : String?
    public var minLength : Int?
    public var maxLength : Int?
    
    public class func fromJSON(json : NSDictionary) -> IdentificationType {
        var identificationType : IdentificationType = IdentificationType()
        identificationType.id = JSON(json["id"]!).asString
        identificationType.name = JSON(json["name"]!).asString
        identificationType.type = JSON(json["type"]!).asString
        identificationType.minLength = json["min_length"] as? Int
        identificationType.maxLength = json["max_length"] as? Int
        return identificationType
    }
}