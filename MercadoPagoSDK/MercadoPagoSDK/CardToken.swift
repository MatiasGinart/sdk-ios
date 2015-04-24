//
//  CardToken.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class CardToken : NSObject {
    
    let MIN_LENGTH_NUMBER : Int = 10
    let MAX_LENGTH_NUMBER : Int = 19
    let now = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth, fromDate: NSDate())
    
    public var cardNumber : String?
    public var securityCode : String?
    public var expirationMonth : Int?
    public var expirationYear : Int?
    public var cardholder : Cardholder?
    public var device : Device?
    
    public init (cardNumber: String?, expirationMonth: Int?, expirationYear: Int?,
        securityCode: String?, cardholderName: String, docType: String, docNumber: String) {
            super.init()
            self.cardholder = Cardholder()
            self.cardholder?.name = cardholderName
            self.cardholder?.identification = Identification()
            self.cardholder?.identification?.number = docNumber
            self.cardholder?.identification?.type = docType
            self.cardNumber = normalizeCardNumber(cardNumber)
            self.expirationMonth = expirationMonth
            self.expirationYear = normalizeYear(expirationYear)
            self.securityCode = securityCode
    }
    
    public func normalizeCardNumber(number: String?) -> String? {
        if number == nil {
            return nil
        }
        return number!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString("\\s+|-", withString: "")
    }
    
    public func validate() -> Bool {
        return validate(true)
    }
    
    public func validate(includeSecurityCode: Bool) -> Bool {
        var result : Bool = validateCardNumber() == nil  && validateExpiryDate() == nil && validateIdentification() == nil && validateCardholderName() == nil
        if (includeSecurityCode) {
            result = result && validateSecurityCode() == nil
        }
        return result
    }
    
    public func validateCardNumber() -> NSError? {
        
        var userInfo : [String : String]?
        if String.isNullOrEmpty(cardNumber) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["cardNumber" : "Ingresa el número de la tarjeta de crédito"])
        } else if count(self.cardNumber!) < MIN_LENGTH_NUMBER {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["cardNumber" : "Debes ingresar al menos \(MIN_LENGTH_NUMBER) números"])
        } else if count(self.cardNumber!) > MAX_LENGTH_NUMBER {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["cardNumber" : "Debes ingresar a lo sumo \(MAX_LENGTH_NUMBER) números"])
        } else {
            return nil
        }
    }
    
    public func validateCardNumber(paymentMethod: PaymentMethod) -> NSError? {
        var userInfo : [String : String]?
        
        let validCardNumber = self.validateCardNumber()
        if validCardNumber != nil {
            return validCardNumber
        } else {
        
            let setting : Setting? = Setting.getSettingByBin(paymentMethod.settings, bin: getBin())
            
            if setting == nil {
                if userInfo == nil {
                    userInfo = [String : String]()
                }
                userInfo?.updateValue("El número de tarjeta que ingresaste no se corresponde con el tipo de tarjeta", forKey: "cardNumber")
            } else {
                
                // Validate card length
                if (count(cardNumber!) != setting?.cardNumber.length) {
                    if userInfo == nil {
                        userInfo = [String : String]()
                    }
                    userInfo?.updateValue("Ingresa los \(setting?.cardNumber.length) número de la tarjeta", forKey: "cardNumber")
                }
                
                // Validate luhn
                if "standard" == setting?.cardNumber.validation && !checkLuhn(cardNumber!) {
                    if userInfo == nil {
                        userInfo = [String : String]()
                    }
                    userInfo?.updateValue("El número de tarjeta que ingresaste es incorrecto", forKey: "cardNumber")
                }
            }
        }
        
        if userInfo == nil {
            return nil
        } else {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: userInfo)
        }
    }
    
    public func validateSecurityCode()  -> NSError? {
        return validateSecurityCode(securityCode)
    }
    
    public func validateSecurityCode(securityCode: String?) -> NSError? {
        if String.isNullOrEmpty(self.securityCode) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["securityCode" : "Debes ingresar el código de seguridad"])
        } else if count(self.securityCode!) < 3 || count(self.securityCode!) > 4 {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["securityCode" : "Debes ingresar un código de seguridad correcto"])
        } else {
            return nil
        }
    }
    
    public func validateSecurityCodeWithPaymentMethod(paymentMethod: PaymentMethod) -> NSError? {
        let validSecurityCode = self.validateSecurityCode(securityCode)
        if validSecurityCode != nil {
            return validSecurityCode
        } else {
            let range = Range(start: cardNumber!.startIndex,
                end: advance(cardNumber!.startIndex, 6))
            return validateSecurityCodeWithPaymentMethod(securityCode!, paymentMethod: paymentMethod, bin: cardNumber!.substringWithRange(range))
        }
    }
    
    public func validateSecurityCodeWithPaymentMethod(securityCode: String, paymentMethod: PaymentMethod, bin: String) -> NSError? {
        let setting : Setting? = Setting.getSettingByBin(paymentMethod.settings, bin: getBin())
        // Validate security code length
        let cvvLength = setting?.securityCode.length
        if ((cvvLength != 0) && (count(securityCode) != cvvLength)) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["securityCode" : "Ingresa los \(cvvLength) números del código de seguridad"])
        } else {
            return nil
        }
    }
    
    public func validateExpiryDate() -> NSError? {
        return validateExpiryDate(expirationMonth, year: expirationYear)
    }
    
    public func validateExpiryDate(month: Int?, year: Int?) -> NSError? {
        if !validateExpMonth(month) {
            if month == nil {
                return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["expiryDate" : "Debes indicar el mes"])
            } else {
                return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["expiryDate" : "El mes \(month!) es inválido"])
            }
        }
        if !validateExpYear(year) {
            if year == nil {
                return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["expiryDate" : "Debes indicar el año"])
            } else {
                return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["expiryDate" : "El año ingresado no es válido"])
            }
        }
        
        if hasMonthPassed(self.expirationYear!, month: self.expirationMonth!) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["expiryDate" : "El mes y año de expiración deben ser posterior a \(now.month+1)/\(now.year)"])
        }
        
        return nil
    }
    
    public func validateExpMonth(month: Int?) -> Bool {
        if month == nil {
            return false
        }
        return (month! >= 1 && month! <= 12)
    }
    
    public func validateExpYear(year: Int?) -> Bool {
        if year == nil {
            return false
        }
        return !hasYearPassed(year!)
    }
    
    public func validateIdentification() -> NSError? {
        
        let validType = validateIdentificationType()
        if validType != nil {
            return validType
        } else {
            let validNumber = validateIdentificationNumber()
            if validNumber != nil {
                return validNumber
            }
        }
        return nil
    }
    
    public func validateIdentificationType() -> NSError? {
        
        if String.isNullOrEmpty(cardholder!.identification!.type) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["identification" : "Debes indicar el tipo de documento"])
        } else {
            return nil
        }
    }
    
    public func validateIdentificationNumber() -> NSError? {
        
        if String.isNullOrEmpty(cardholder!.identification!.number) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["identification" : "Debes indicar el documento"])
        } else {
            return nil
        }
    }
    
    public func validateIdentificationNumber(identificationType: IdentificationType?) -> NSError? {
        if identificationType != nil {
            if cardholder?.identification != nil && cardholder?.identification?.number != nil {
                let len = count(cardholder!.identification!.number!)
                let min = identificationType!.minLength
                let max = identificationType!.maxLength
                if min != nil && max != nil {
                    if len > max && len < min {
                        return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["identification" : "El documento debe tener entre \(min) y \(max) caracteres"])
                    } else {
                        return nil
                    }
                } else  {
                    return validateIdentificationNumber()
                }
            } else {
                return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["identification" : "Debes indicar el documento"])
            }
        } else {
            return validateIdentificationNumber()
        }
    }
    
    public func validateCardholderName() -> NSError? {
        if String.isNullOrEmpty(self.cardholder?.name) {
            return NSError(domain: "mercadopago.sdk.card.error", code: 1, userInfo: ["cardholder" : "Debes indicar el nombre que figura en la tarjeta"])
        } else {
            return nil
        }
    }

    public func hasYearPassed(year: Int?) -> Bool {
        let aux : Int? = normalizeYear(year)
        let normalized : Int = aux == nil ? Int.min : aux!
        return normalized < now.year
    }
    
    public func hasMonthPassed(year: Int, month: Int) -> Bool {
        return hasYearPassed(year) || normalizeYear(year) == now.year && month < (now.month + 1)
    }
    
    public func normalizeYear(year: Int?) -> Int? {
        if year == nil {
            return nil
        }
        if year < 100 && year >= 0 {
            let currentYear : String = String(now.year)
            let range = Range(start: currentYear.startIndex,
                end: advance(currentYear.endIndex, -2))
            let prefix : String = currentYear.substringWithRange(range)
            return String(prefix + String(year!)).toInt()!
        }
        return year
    }
    
    public func checkLuhn(cardNumber : String) -> Bool {
        var sum : Int = 0
        var alternate = false
        if count(cardNumber) == 0 {
            return false
        }
        
        for var index = (count(cardNumber)-1); index >= 0; index-- {
            let range = NSRange(location: index, length: 1)
            var s = cardNumber as NSString
            s = s.substringWithRange(NSRange(location: index, length: 1))
            var n : Int = s.integerValue
            if (alternate)
            {
                n *= 2
                if (n > 9)
                {
                    n = (n % 10) + 1
                }
            }
            sum += n
            alternate = !alternate
        }
        
        return (sum % 10 == 0)
    }
    
    public func getBin() -> String? {
        let range = Range(start: cardNumber!.startIndex, end: advance(cardNumber!.startIndex, 6))
        var bin :String? = count(cardNumber!) >= 6 ? cardNumber!.substringWithRange(range) : nil
        return bin
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "card_number": String.isNullOrEmpty(self.cardNumber) ? JSON.null : self.cardNumber!,
            "security_code" : String.isNullOrEmpty(self.securityCode) ? JSON.null : self.securityCode!,
            "expiration_month" : self.expirationMonth == nil ? JSON.null : self.expirationMonth!,
            "expiration_year" : self.expirationYear == nil ? JSON.null : self.expirationYear!,
            "cardholder" : self.cardholder == nil ? JSON.null : JSON.parse(self.cardholder!.toJSONString()).mutableCopyOfTheObject(),
            "device" : self.device == nil ? JSON.null : self.device!.toJSONString()
        ]
        return JSON(obj).toString()
    }
}