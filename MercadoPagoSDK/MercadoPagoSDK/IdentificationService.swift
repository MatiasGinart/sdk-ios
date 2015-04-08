//
//  IdentificationService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 5/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
public class IdentificationService : MercadoPagoService {
    public func getIdentificationTypes(method: String = "GET", uri : String = "/identification_types", public_key : String?, privateKey: String?, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        var params : String? = nil
        if public_key != nil {
            params = "public_key=" + public_key!
        }
        if privateKey != nil {
            if params != nil {
                params = params! + "&"
            } else {
                params = ""
            }
            params = params! + "access_token=" + privateKey!
        }
        self.request(uri, params: params, body: nil, method: method, success: success, failure: failure)
    }
}