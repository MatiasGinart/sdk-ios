//
//  PaymentService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class PaymentService : MercadoPagoService {
    
    public func getPaymentMethods(method: String = "GET", uri : String = "/v1/payment_methods", public_key : String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(uri, params: "public_key=" + public_key, body: nil, method: method, success: success, failure: failure)
    }

    public func getInstallments(method: String = "GET", uri : String = "/v1/payment_methods/installments", public_key : String, bin : String, amount: Double, issuer_id: Int64?, payment_type_id: String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        var params : String = "public_key=" + public_key
            params = params + "&bin=" + bin
            params = params + "&amount=" + String(format:"%.2f", amount)
        if issuer_id != nil {
            params = params + "&issuer.id=" + String(format:"%d", issuer_id!)
        }
            params = params + "&payment_type_id=" + payment_type_id
        self.request(uri, params: params, body: nil, method: method, success: success, failure: failure)
    }
    
    public func getIssuers(method: String = "GET", uri : String = "/v1/payment_methods/card_issuers", public_key : String, payment_method_id: String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(uri, params: "public_key=" + public_key + "&payment_method_id=" + payment_method_id, body: nil, method: method, success: success, failure: failure)
    }
    
}