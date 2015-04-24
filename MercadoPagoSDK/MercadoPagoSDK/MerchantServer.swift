//
//  MerchantServer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MerchantServer : NSObject {
    
    public override init() {
        
    }
    
    public class func getCustomer(merchantBaseUrl : String, merchantGetCustomerUri : String,  merchantAccessToken : String, success: (customer: Customer) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : MerchantService = MerchantService(baseURL: merchantBaseUrl, getCustomerUri: merchantGetCustomerUri)

        service.getCustomer(merchant_access_token: merchantAccessToken, success: {(jsonResult: AnyObject?) -> Void in
            var cust : Customer? = nil
            if let custDic = jsonResult as? NSDictionary {
                if custDic["error"] != nil {
                    if failure != nil {
                        failure!(error: NSError(domain: "mercadopago.sdk.merchantServer.getCustomer", code: MercadoPago.ERROR_API_CODE, userInfo: custDic as [NSObject : AnyObject]))
                    }
                } else {
                    cust = Customer.fromJSON(custDic)
                    success(customer: cust!)
                }
            } else {
                if failure != nil {
                    failure!(error: NSError(domain: "mercadopago.sdk.merchantServer.getCustomer", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
                }
            }
        }, failure: failure)
    }
    
    public class func createPayment(merchantBaseUrl : String, merchantPaymentUri : String, payment : MerchantPayment, success: (payment: Payment) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : MerchantService = MerchantService(baseURL: merchantBaseUrl, createPaymentUri: merchantPaymentUri)
        service.createPayment(payment: payment, success: {(jsonResult: AnyObject?) -> Void in
            var payment : Payment? = nil
            
            if let paymentDic = jsonResult as? NSDictionary {
                if paymentDic["error"] != nil {
                    if failure != nil {
                        failure!(error: NSError(domain: "mercadopago.sdk.merchantServer.createPayment", code: MercadoPago.ERROR_API_CODE, userInfo: paymentDic as [NSObject : AnyObject]))
                    }
                } else {
                    payment = Payment.fromJSON(paymentDic)
                    success(payment: payment!)
                }
            } else {
                if failure != nil {
                    failure!(error: NSError(domain: "mercadopago.sdk.merchantServer.createPayment", code: MercadoPago.ERROR_UNKNOWN_CODE, userInfo: ["message": "Response cannot be decoded"]))
                }
            }
        }, failure: failure)
    }
}