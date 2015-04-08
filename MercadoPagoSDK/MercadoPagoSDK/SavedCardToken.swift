//
//  SavedCard.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class SavedCardToken : NSObject {
    public var cardId : String?
    public var securityCode : String?
    public var device : Device?
    public var securityCodeRequired : Bool = true
    
    public init(cardId : String, securityCode : String) {
        super.init()
        self.cardId = cardId
        self.securityCode = securityCode
    }
    
    public init(cardId : String, securityCode : String?, securityCodeRequired: Bool) {
        super.init()
        self.cardId = cardId
        self.securityCode = securityCode
        self.securityCodeRequired = securityCodeRequired
    }
    
    public func validate() -> Bool {
        return validateCardId() && (!securityCodeRequired || validateSecurityCode())
    }
    
    public func validateCardId() -> Bool {
        return !String.isNullOrEmpty(cardId) && String.isDigitsOnly(cardId!)
    }
    
    public func validateSecurityCode() -> Bool {
        let isEmptySecurityCode : Bool = String.isNullOrEmpty(self.securityCode)
        return !isEmptySecurityCode && self.securityCode?.utf16Count >= 3 && self.securityCode?.utf16Count <= 4
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "card_id": String.isNullOrEmpty(self.cardId) ? JSON.null : self.cardId!,
            "security_code" : String.isNullOrEmpty(self.securityCode) ? JSON.null : self.securityCode!,
            "device" : self.device == nil ? JSON.null : self.device!.toJSONString()
        ]
        return JSON(obj).toString()
    }
}