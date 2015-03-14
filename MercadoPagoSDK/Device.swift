//
//  Device.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class Device {
    var fingerprint : Fingerprint
    
    init() {
        self.fingerprint = Fingerprint()
    }
    
    func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "fingerprint": self.fingerprint.toJSONString()
        ]
        return JSON(obj).toString()
    }
}