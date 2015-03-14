//
//  TransactionDetails.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class TransactionDetails {
    var couponAmount : Double!
    var externalResourceUrl : String!
    var financialInstitution : String!
    var installmentAmount : Double!
    var netReceivedAmount : Double!
    var overpaidAmount : Double!
    var totalPaidAmount : Double!
    
    class func fromJSON(json : NSDictionary) -> TransactionDetails {
        var transactionDetails : TransactionDetails = TransactionDetails()
        if json["coupon_amount"] != nil {
            transactionDetails.couponAmount = JSON(json["coupon_amount"]!).asDouble
        }
        transactionDetails.externalResourceUrl = JSON(json["external_resource_url"]!).asString
        transactionDetails.financialInstitution = JSON(json["financial_institution"]!).asString
        transactionDetails.installmentAmount = JSON(json["installment_amount"]!).asDouble
        transactionDetails.netReceivedAmount = JSON(json["net_received_amount"]!).asDouble
        transactionDetails.overpaidAmount = JSON(json["overpaid_amount"]!).asDouble
        transactionDetails.totalPaidAmount = JSON(json["total_paid_amount"]!).asDouble
        return transactionDetails
    }
}