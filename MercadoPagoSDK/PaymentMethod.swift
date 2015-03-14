//
//  PaymentMethod.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class PaymentMethod {
    var id : String!
    var name : String!
    var paymentTypeId : String!
    var settings : [Setting]!
    var additionalInfoNeeded : [String]!
    
    func isIssuerRequired() -> Bool {
        return isAdditionalInfoNeeded("issuer_id")
    }
    
    func isSecurityCodeRequired(bin: String) -> Bool {
        
        let setting : Setting? = Setting.getSettingByBin(settings, bin: bin)
        if setting != nil && setting!.securityCode.length != 0 {
            return true
        } else {
            return false
        }
    }
    
    func isAdditionalInfoNeeded(param: String!) -> Bool {
        if additionalInfoNeeded != nil && additionalInfoNeeded.count > 0 {
            for info in additionalInfoNeeded {
                if info == param {
                    return true
                }
            }
        }
        return false
    }
    
    init () {}
    
    class func fromJSON(json : NSDictionary) -> PaymentMethod {
        var paymentMethod : PaymentMethod = PaymentMethod()
        paymentMethod.id = JSON(json["id"]!).asString
        paymentMethod.name = JSON(json["name"]!).asString
        paymentMethod.paymentTypeId = JSON(json["payment_type_id"]!).asString
        var settings : [Setting] = [Setting]()
        if let settingsArray = json["settings"] as? NSArray {
            for i in 0..<settingsArray.count {
                if let settingDic = settingsArray[i] as? NSDictionary {
                    settings.append(Setting.fromJSON(settingDic))
                }
            }
        }
        paymentMethod.settings = settings
        var additionalInfoNeeded : [String] = [String]()
        if let additionalInfoNeededArray = json["additional_info_needed"] as? NSArray {
            for i in 0..<additionalInfoNeededArray.count {
                if let additionalInfoNeededStr = additionalInfoNeededArray[i] as? String {
                    additionalInfoNeeded.append(additionalInfoNeededStr)
                }
            }
        }
        paymentMethod.additionalInfoNeeded = additionalInfoNeeded
        return paymentMethod
    }
}