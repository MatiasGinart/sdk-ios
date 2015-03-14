//
//  Setting.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Setting {
    var bin : Bin!
    var cardNumber : CardNumber!
    var securityCode : SecurityCode!
    
    class func getSettingByBin(settings: [Setting]!, bin: String!) -> Setting? {
        var selectedSetting : Setting? = nil
        if settings != nil && settings.count > 0 {
            for setting in settings {
                
                if "" != bin && Regex(setting.bin!.pattern! + ".*").test(bin) &&
                    (String.isNullOrEmpty(setting.bin!.exclusionPattern) || !Regex(setting.bin!.exclusionPattern! + ".*").test(bin!)) {
                    selectedSetting = setting
                }
            }
        }
        return selectedSetting
    }
    
    class func fromJSON(json : NSDictionary) -> Setting {
        var setting : Setting = Setting()
        setting.bin = Bin.fromJSON(json["bin"]!  as NSDictionary)
        if json["card_number"] != nil {
            setting.cardNumber = CardNumber.fromJSON(json["card_number"]! as NSDictionary)
        }
        setting.securityCode = SecurityCode.fromJSON(json["security_code"]! as NSDictionary)
        return setting
    }
}