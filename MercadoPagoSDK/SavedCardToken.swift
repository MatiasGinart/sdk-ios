//
//  SavedCard.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class SavedCardToken {
    var cardId : String?
    var securityCode : String?
    var device : Device?
    var securityCodeRequired : Bool = true
    
    init() {}
    
    init(cardId : String, securityCode : String) {
        self.cardId = cardId
        self.securityCode = securityCode
    }
    
    init(cardId : String, securityCode : String?, securityCodeRequired: Bool) {
        self.cardId = cardId
        self.securityCode = securityCode
        self.securityCodeRequired = securityCodeRequired
    }
    
    func validate() -> Bool {
        return validateCardId() && (!securityCodeRequired || validateSecurityCode())
    }
    
    func validateCardId() -> Bool {
        return !String.isNullOrEmpty(cardId) && String.isDigitsOnly(cardId!)
    }
    
    func validateSecurityCode() -> Bool {
        let isEmptySecurityCode : Bool = String.isNullOrEmpty(self.securityCode)
        return !isEmptySecurityCode && self.securityCode?.utf16Count >= 3 && self.securityCode?.utf16Count <= 4
    }
    
    func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "card_id": String.isNullOrEmpty(self.cardId) ? JSON.null : self.cardId!,
            "security_code" : String.isNullOrEmpty(self.securityCode) ? JSON.null : self.securityCode!,
            "device" : self.device == nil ? JSON.null : self.device!.toJSONString()
        ]
        return JSON(obj).toString()
    }
}