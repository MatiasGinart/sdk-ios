//
//  MerchantServer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MerchantServer {
    
    init() {
        
    }
    
    class func getCustomer(merchantBaseUrl : String, merchantGetCustomerUri : String,  merchantAccessToken : String, success: (customer: Customer) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : MerchantService = MerchantService(baseURL: merchantBaseUrl, getCustomerUri: merchantGetCustomerUri)

        service.getCustomer(merchant_access_token: merchantAccessToken, success: {(jsonResult: AnyObject?) -> Void in
            var cust : Customer? = nil
            if let custDic = jsonResult as? NSDictionary {
                cust = Customer.fromJSON(custDic)
            }
            success(customer: cust!)
            }, failure: failure)
    }
    
    class func createPayment(merchantBaseUrl : String, merchantPaymentUri : String, payment : MerchantPayment, success: (payment: Payment) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : MerchantService = MerchantService(baseURL: merchantBaseUrl, createPaymentUri: merchantPaymentUri)
        service.createPayment(payment: payment, success: {(jsonResult: AnyObject?) -> Void in
            var payment : Payment? = nil
            if let paymentDic = jsonResult as? NSDictionary {
                payment = Payment.fromJSON(paymentDic)
                success(payment: payment!)
            } else {
              failure?(error: NSError())
            }

            }, failure: failure)
    }
    
    class func getDiscount(merchantBaseUrl : String, merchantGetDiscountUri : String, merchantAccessToken : String, itemId: String, itemQuantity: Int, success: (discount: Discount?) -> Void, failure: ((error: NSError) -> Void)?) {
        let service : MerchantService = MerchantService(baseURL: merchantBaseUrl, getDiscountUri: merchantGetDiscountUri)
        service.getDiscount(merchant_access_token: merchantAccessToken, item_id: itemId, item_quantity: itemQuantity, success: {(jsonResult: AnyObject?) -> Void in
            var disc : Discount? = nil
            if let discDic = jsonResult as? NSDictionary {
                disc = Discount.fromJSON(discDic)
            }
            success(discount: disc)
            }, failure: failure)
    }
}