//
//  PayerCost.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class PayerCost : NSObject {
    public var installments : Int = 0
    public var installmentRate : Double = 0
    public var labels : [String]!
    public var minAllowedAmount : Double = 0
    public var maxAllowedAmount : Double = 0
    public var recommendedMessage : String!
    public var installmentAmount : Double = 0
    public var totalAmount : Double = 0
    
    public init (installments : Int, installmentRate : Double, labels : [String],
        minAllowedAmount : Double, maxAllowedAmount : Double, recommendedMessage: String!, installmentAmount: Double, totalAmount: Double) {
            super.init()
            self.installments = installments
        self.installmentRate = installmentRate
        self.labels = labels
        self.minAllowedAmount = minAllowedAmount
        self.maxAllowedAmount = maxAllowedAmount
        self.recommendedMessage = recommendedMessage
        self.installmentAmount = installmentAmount
        self.totalAmount = totalAmount
    }
    
    public override init() {
        super.init()
    }
    
    public class func fromJSON(json : NSDictionary) -> PayerCost {
        var payerCost : PayerCost = PayerCost()
		if json["installments"] != nil && !(json["installments"]! is NSNull) {
			payerCost.installments = JSON(json["installments"]!).asInt!
		}
		if json["installment_rate"] != nil && !(json["installment_rate"]! is NSNull) {
			payerCost.installmentRate = JSON(json["installment_rate"]!).asDouble!
		}
		if json["min_allowed_amount"] != nil && !(json["min_allowed_amount"]! is NSNull) {
			payerCost.minAllowedAmount = JSON(json["min_allowed_amount"]!).asDouble!
		}
		if json["max_allowed_amount"] != nil && !(json["max_allowed_amount"]! is NSNull) {
			payerCost.maxAllowedAmount = JSON(json["max_allowed_amount"]!).asDouble!
		}
		if json["installment_amount"] != nil && !(json["installment_amount"]! is NSNull) {
			payerCost.installmentAmount = JSON(json["installment_amount"]!).asDouble!
		}
		if json["total_amount"] != nil && !(json["total_amount"]! is NSNull) {
			payerCost.totalAmount = JSON(json["total_amount"]!).asDouble!
		}
        payerCost.recommendedMessage = JSON(json["recommended_message"]!).asString
        return payerCost
    }
}