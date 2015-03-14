//
//  Token.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

@objc class Token {
    var id : String
    var publicKey : String
    var cardId : String?
    var luhnValidation : String?
    var status : String?
    var usedDate : String?
    var cardNumberLength : Int?
    var creationDate : NSDate?
    var truncCardNumber : String?
    var securityCodeLength : Int?
    var expirationMonth : Int?
    var expirationYear : Int?
    var lastModifiedDate : NSDate?
    var dueDate : NSDate?
    
    init (id: String, publicKey: String, cardId: String?, luhnValidation: String?, status: String?,
        usedDate: String?, cardNumberLength: Int?, creationDate: NSDate?, truncCardNumber: String?,
        securityCodeLength: Int?, expirationMonth: Int?, expirationYear: Int?, lastModifiedDate: NSDate?,
        dueDate: NSDate?) {
            self.id = id
            self.publicKey = publicKey
            self.cardId = cardId
            self.luhnValidation = luhnValidation
            self.status = status
            self.usedDate = usedDate
            self.cardNumberLength = cardNumberLength
            self.creationDate = creationDate
            self.truncCardNumber = truncCardNumber
            self.securityCodeLength = securityCodeLength
            self.expirationMonth = expirationMonth
            self.expirationYear = expirationYear
            self.lastModifiedDate = lastModifiedDate
            self.dueDate = dueDate
    }
    
    class func fromJSON(json : NSDictionary) -> Token {
        let id = JSON(json["id"]!).asString!
        let publicKey = JSON(json["public_key"]!).asString!
        let cardId = json["card_id"] == nil ? nil : JSON(json["card_id"]!).asString
        let status = JSON(json["status"]!).asString
        let luhn = json["luhn_validation"] == nil ? nil : JSON(json["luhn_validation"]!).asString
        let usedDate = json["used_date"] == nil ? nil : JSON(json["used_date"]!).asString
        let cardNumberLength = json["card_number_length"] == nil ? nil : JSON(json["card_number_length"]!).asInt
        let creationDate = JSON(json["creation_date"]!).asDate
        let truncCardNumber = json["trunc_card_number"] == nil ? nil : JSON(json["trunc_card_number"]!).asString
        let securityCodeLength = JSON(json["security_code_length"]!).asInt
        let expMonth = json["expiration_month"] == nil ? nil : JSON(json["expiration_month"]!).asInt
        let expYear = json["expiration_year"] == nil ? nil : JSON(json["expiration_year"]!).asInt
        let lastModifiedDate = JSON(json["last_modified_date"]!).asDate
        let dueDate = JSON(json["due_date"]!).asDate
        return Token(id: id, publicKey: publicKey, cardId: cardId, luhnValidation: luhn, status: status,
            usedDate: usedDate, cardNumberLength: cardNumberLength, creationDate: creationDate, truncCardNumber: truncCardNumber,
            securityCodeLength: securityCodeLength, expirationMonth: expMonth, expirationYear: expYear, lastModifiedDate: lastModifiedDate,
            dueDate: dueDate)
    }
}