//
//  PayerCost.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class PayerCost {
    var installments : Int?
    var installmentRate : Double?
    var labels : [String]?
    var minAllowedAmount : Double?
    var maxAllowedAmount : Double?
    var recommendedMessage : String!
    var installmentAmount : Double!
    var totalAmount : Double!
    
    init (installments : Int, installmentRate : Double, labels : [String],
        minAllowedAmount : Double, maxAllowedAmount : Double, recommendedMessage: String!, installmentAmount: Double!, totalAmount: Double!) {
        self.installments = installments
        self.installmentRate = installmentRate
        self.labels = labels
        self.minAllowedAmount = minAllowedAmount
        self.maxAllowedAmount = maxAllowedAmount
        self.recommendedMessage = recommendedMessage
        self.installmentAmount = installmentAmount
        self.totalAmount = totalAmount
    }
    
    init () {}
    
    class func fromJSON(json : NSDictionary) -> PayerCost {
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