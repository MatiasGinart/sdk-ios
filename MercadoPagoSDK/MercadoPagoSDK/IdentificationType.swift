//
//  IdentificationType.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 2/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class IdentificationType : NSObject {
    public var _id : String?
    public var name : String?
    public var type : String?
    public var minLength : Int = 0
    public var maxLength : Int = 0
    
    public class func fromJSON(json : NSDictionary) -> IdentificationType {
        var identificationType : IdentificationType = IdentificationType()
        identificationType._id = JSON(json["id"]!).asString
        identificationType.name = JSON(json["name"]!).asString
        identificationType.type = JSON(json["type"]!).asString
		
		if json["min_length"] != nil && !(json["min_length"]! is NSNull) {
			identificationType.minLength = (json["min_length"] as? Int)!
		}
		if json["max_length"] != nil && !(json["max_length"]! is NSNull) {
			identificationType.maxLength = (json["max_length"] as? Int)!
		}
		
        return identificationType
    }
}