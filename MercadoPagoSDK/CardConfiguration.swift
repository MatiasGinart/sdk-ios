//
//  CardConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class CardConfiguration {
    var binCardPattern : String?
    var binCardExclusionPattern : String?
    var cardNumberLength : Int?
    var securityCodeLength : Int?
    var luhnAlgorithm : String?
    var additionalInfoNeeded : [String]?
    var exceptionsByCardValidations : String?
    
    init() {
        
    }
    
    init (binCardPattern : String?, binCardExclusionPattern : String?,
        cardNumberLength : Int, securityCodeLength : Int,
        luhnAlgorithm : String?, additionalInfoNeeded : [String]?,
        exceptionsByCardValidations : String?) {
            self.binCardPattern = binCardPattern
            self.binCardExclusionPattern = binCardExclusionPattern
            self.cardNumberLength = cardNumberLength
            self.securityCodeLength = securityCodeLength
            self.luhnAlgorithm = luhnAlgorithm
            self.additionalInfoNeeded = additionalInfoNeeded
            self.exceptionsByCardValidations = exceptionsByCardValidations
    }
    
    class func fromJSON(json : NSDictionary) -> CardConfiguration {

        var additionalInfoNedded : [String] = [String]()

        if let ain = json["additional_info_needed"] as? NSArray {
            for i in 0..<ain.count {
                if let ai = ain[i] as? String {
                    additionalInfoNedded.append(ai)
                }
            }
        }
        
        return CardConfiguration(binCardPattern: JSON(json["bin_card_pattern"]!).asString, binCardExclusionPattern: JSON(json["bin_card_exclusion_pattern"]!).asString, cardNumberLength: JSON(json["card_number_length"]!).asString!.toInt()!, securityCodeLength: JSON(json["security_code_length"]!).asInt!, luhnAlgorithm: JSON(json["luhn_algorithm"]!).asString, additionalInfoNeeded: additionalInfoNedded, exceptionsByCardValidations: nil)
    }
}