//
//  MerchantService.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MerchantService : MercadoPagoService {
    
    var createPaymentUri : String?
    var getCustomerUri : String?
    var getDiscountUri : String?
    
    var data: NSMutableData = NSMutableData()
    
    init (baseURL : String, getCustomerUri : String) {
        super.init(baseURL: baseURL)
        self.getCustomerUri = getCustomerUri
    }
    
    init (baseURL : String, createPaymentUri : String) {
        super.init(baseURL: baseURL)
        self.createPaymentUri = createPaymentUri
    }
    
    init (baseURL : String, getDiscountUri : String) {
        super.init(baseURL: baseURL)
        self.getDiscountUri = getDiscountUri
    }
    
    func getCustomer(method : String = "GET", merchant_access_token : String, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(getCustomerUri!, params: "merchant_access_token=" + merchant_access_token, body: nil, method: method, success: success, failure: failure)
    }
    
    func createPayment(method : String = "POST", payment : MerchantPayment, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(createPaymentUri!, params: nil, body: payment.toJSONString(), method: method, success: success, failure: failure)
    }
    
    func getDiscount(method : String = "GET", merchant_access_token : String, item_id: String, item_quantity: Int, success: (jsonResult: AnyObject?) -> Void, failure: ((error: NSError) -> Void)?) {
        self.request(getDiscountUri!, params: "merchant_access_token=" + merchant_access_token + "&item.id=" + item_id + "&item.quantity=" + String(format:"%d", item_quantity), body: nil, method: method, success: success, failure: failure)
    }
}