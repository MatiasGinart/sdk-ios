//
//  MerchantPayment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class MerchantPayment {
    var cardIssuerId : Int?
    var cardToken : String!
    var discountId : Int?
    var installments : Int?
    var item : Item!
    var merchantAccessToken : String!
    var paymentMethodId : String!
    
    init() {}
    
    init(item: Item, installments: Int?, cardIssuerId: Int?, token: String, paymentMethodId: String, discountId: Int?, merchantAccessToken: String) {
        self.item = item
        self.installments = installments
        self.cardIssuerId = cardIssuerId
        self.cardToken = token
        self.paymentMethodId = paymentMethodId
        self.discountId = discountId
        self.merchantAccessToken = merchantAccessToken
    }
    
    func toJSONString() -> String {
        let obj:[String:AnyObject] = [
            "card_issuer_id": self.cardIssuerId == nil ? JSON.null : String(self.cardIssuerId!),
            "card_token": self.cardToken == nil ? JSON.null : self.cardToken!,
            "campaign_id": self.discountId == nil ? JSON.null : String(self.discountId!),
            "item": self.item == nil ? JSON.null : JSON.parse(self.item!.toJSONString()).mutableCopyOfTheObject(),
            "installments" : self.installments == nil ? JSON.null : self.installments!,
            "merchant_access_token" : self.merchantAccessToken == nil ? JSON.null : self.merchantAccessToken!,
            "payment_method_id" : self.paymentMethodId == nil ? JSON.null : self.paymentMethodId!
        ]
        return JSON(obj).toString()
    }
    
}