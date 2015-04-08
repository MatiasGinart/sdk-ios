//
//  PayerCost.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class PayerCost : NSObject {
    public var installments : Int!
    public var installmentRate : Double!
    public var labels : [String]!
    public var minAllowedAmount : Double!
    public var maxAllowedAmount : Double!
    public var recommendedMessage : String!
    public var installmentAmount : Double!
    public var totalAmount : Double!
    
    public init (installments : Int, installmentRate : Double, labels : [String],
        minAllowedAmount : Double, maxAllowedAmount : Double, recommendedMessage: String!, installmentAmount: Double!, totalAmount: Double!) {
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
        payerCost.installments = JSON(json["installments"]!).asInt
        payerCost.installmentRate = JSON(json["installment_rate"]!).asDouble
        payerCost.minAllowedAmount = JSON(json["min_allowed_amount"]!).asDouble
        payerCost.maxAllowedAmount = JSON(json["max_allowed_amount"]!).asDouble
        payerCost.recommendedMessage = JSON(json["recommended_message"]!).asString
        payerCost.installmentAmount = JSON(json["installment_amount"]!).asDouble
        payerCost.totalAmount = JSON(json["total_amount"]!).asDouble
        return payerCost
    }
}