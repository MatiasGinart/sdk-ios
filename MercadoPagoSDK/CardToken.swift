//
//  CardToken.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class CardToken {
    
    let MIN_LENGTH_NUMBER : Int = 10
    let MAX_LENGTH_NUMBER : Int = 19
    
    let now = NSCalendar.currentCalendar().components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: NSDate())
    
    var cardNumber : String?
    var securityCode : String?
    var expirationMonth : Int?
    var expirationYear : Int?
    var cardholder : Cardholder?
    var device : Device?
    
    init (cardNumber: String?, expirationMonth: Int?, expirationYear: Int?,
        securityCode: String?, cardholderName: String, docType: String, docNumber: String) {
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
    
    func normalizeCardNumber(number: String?) -> String? {
        if number == nil {
            return nil
        }
        return number!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString("\\s+|-", withString: "")
    }
    
    func validate() -> Bool {
        return validate(true)
    }
    
    func validate(includeSecurityCode: Bool) -> Bool {
        var result : Bool = validateCardNumber()  && validateExpiryDate() && validateIdentification() && validateCardholderName()
        if (includeSecurityCode) {
            result = result && validateSecurityCode()
        }
        return result
    }
    
    func validateCardNumber() -> Bool {
        return !String.isNullOrEmpty(self.cardNumber) && (self.cardNumber?.utf16Count > MIN_LENGTH_NUMBER) && (self.cardNumber?.utf16Count < MAX_LENGTH_NUMBER)
    }
    
    func validateCardNumber(paymentMethod: PaymentMethod) -> Bool {
        
        // Empty field
        if String.isNullOrEmpty(cardNumber) {
            // TODO: "Ingresa el número de la tarjeta de crédito"
            return false
        }
        
        let setting : Setting? = Setting.getSettingByBin(paymentMethod.settings, bin: getBin())
        
        if setting == nil {
            // Validate bin
            // TODO: "El número de tarjeta que ingresaste no se corresponde con el tipo de tarjeta"
            return false
        } else {
            
            // Validate card length
            if (cardNumber?.utf16Count != setting?.cardNumber.length) {
                // TODO: "Ingresa los %1$s números de la tarjeta"
            }
            
            // Validate luhn
            if "standard" == setting?.cardNumber.validation && !checkLuhn(cardNumber!) {
                // TODO: "El número de tarjeta que ingresaste es incorrecto"
                return false
            }
        }
        
        return true
    }
    
    func validateSecurityCode()  -> Bool {
        return validateSecurityCode(securityCode)
    }
    
    func validateSecurityCode(securityCode: String?) -> Bool {
        return !String.isNullOrEmpty(self.securityCode) && self.securityCode?.utf16Count >= 3 && self.securityCode?.utf16Count <= 4
    }
    
    func validateSecurityCode(paymentMethod: PaymentMethod) -> Bool {
        let range = Range(start: cardNumber!.startIndex,
            end: advance(cardNumber!.startIndex, 6))
        return validateSecurityCode(securityCode!, paymentMethod: paymentMethod, bin: cardNumber!.substringWithRange(range))
    }
    
    func validateSecurityCode(securityCode: String, paymentMethod: PaymentMethod, bin: String) -> Bool {
        let setting : Setting? = Setting.getSettingByBin(paymentMethod.settings, bin: getBin())
        // Validate security code length
        let cvvLength = setting?.securityCode.length
        if ((cvvLength != 0) && (securityCode.utf16Count != cvvLength)) {
            // TODO: Ingresa los %1$s números del código de seguridad con param cvvLength
            return false
        }
        return true
    }
    
    func validateExpiryDate() -> Bool {
        return validateExpiryDate(expirationMonth, year: expirationYear)
    }
    
    func validateExpiryDate(month: Int?, year: Int?) -> Bool {
        if !validateExpMonth(month) {
            return true
        }
        if !validateExpYear(year) {
            return false
        }
        return !hasMonthPassed(self.expirationYear!, month: self.expirationMonth!)
    }
    
    func validateExpMonth(month: Int?) -> Bool {
        if month == nil {
            return false
        }
        return (month! >= 1 && month! <= 12)
    }
    
    func validateExpYear(year: Int?) -> Bool {
        if year == nil {
            return false
        }
        return !hasYearPassed(year!)
    }
    
    func validateIdentification() -> Bool {
        return validateIdentificationType() && validateIdentificationNumber()
    }
    
    func validateIdentificationType() -> Bool {
        return !String.isNullOrEmpty(cardholder!.identification!.type)
    }
    
    func validateIdentificationNumber() -> Bool {
        return !String.isNullOrEmpty(cardholder!.identification!.number)
    }
    
    func validateIdentificationNumber(identificationType: IdentificationType?) -> Bool {
        if identificationType != nil {
            if cardholder?.identification != nil && cardholder?.identification?.number != nil {
                let len = cardholder?.identification?.number?.utf16Count
                let min = identificationType!.minLength
                let max = identificationType!.maxLength
                if min != nil && max != nil {
                    return len <= max && len >= min
                } else  {
                    return validateIdentificationNumber()
                }
            } else {
                return false
            }
        } else {
            return validateIdentificationNumber()
        }
    }
    
    func validateCardholderName() -> Bool {
        return !String.isNullOrEmpty(self.cardholder?.name)
    }

    func hasYearPassed(year: Int?) -> Bool {
        let aux : Int? = normalizeYear(year)
        let normalized : Int = aux == nil ? Int.min : aux!
        return normalized < now.year
    }
    
    func hasMonthPassed(year: Int, month: Int) -> Bool {
        return hasYearPassed(year) || normalizeYear(year) == now.year && month < (now.month + 1)
    }
    
    func normalizeYear(year: Int?) -> Int? {
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
    
    func checkLuhn(cardNumber : String) -> Bool {
        var sum : Int = 0
        var alternate = false
        if cardNumber.utf16Count == 0 {
            return false
        }
        
        for var index = (cardNumber.utf16Count-1); index >= 0; index-- {
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
    
    func getBin() -> String? {
        let range = Range(start: cardNumber!.startIndex, end: advance(cardNumber!.startIndex, 6))
        var bin :String? = cardNumber?.utf16Count >= 6 ? cardNumber!.substringWithRange(range) : nil
        return bin
    }
    
    func toJSONString() -> String {
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