//
//  Device.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class Device : NSObject {
    public var fingerprint : Fingerprint!
    
    public override init() {
        super.init()
        self.fingerprint = Fingerprint()
    }
    
    public func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "fingerprint": self.fingerprint.toJSONString()
        ]
        return JSON(obj).toString()
    }
}