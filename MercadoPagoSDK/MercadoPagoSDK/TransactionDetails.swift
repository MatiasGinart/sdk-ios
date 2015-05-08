//
//  TransactionDetails.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class TransactionDetails : NSObject {
    public var couponAmount : Double = 0
    public var externalResourceUrl : String!
    public var financialInstitution : String!
    public var installmentAmount : Double = 0
    public var netReceivedAmount : Double = 0
    public var overpaidAmount : Double = 0
    public var totalPaidAmount : Double = 0
    
    public class func fromJSON(json : NSDictionary) -> TransactionDetails {
        var transactionDetails : TransactionDetails = TransactionDetails()
        if json["coupon_amount"] != nil && !(json["coupon_amount"]! is NSNull) {
            transactionDetails.couponAmount = JSON(json["coupon_amount"]!).asDouble!
        }
        transactionDetails.externalResourceUrl = JSON(json["external_resource_url"]!).asString
        transactionDetails.financialInstitution = JSON(json["financial_institution"]!).asString
		if json["installment_amount"] != nil && !(json["installment_amount"]! is NSNull) {
			transactionDetails.installmentAmount = JSON(json["installment_amount"]!).asDouble!
		}
		if json["net_received_amount"] != nil && !(json["net_received_amount"]! is NSNull) {
			transactionDetails.netReceivedAmount = JSON(json["net_received_amount"]!).asDouble!
		}
		if json["overpaid_amount"] != nil && !(json["overpaid_amount"]! is NSNull) {
			transactionDetails.overpaidAmount = JSON(json["overpaid_amount"]!).asDouble!
		}
		if json["total_paid_amount"] != nil && !(json["total_paid_amount"]! is NSNull) {
			transactionDetails.totalPaidAmount = JSON(json["total_paid_amount"]!).asDouble!
		}
        return transactionDetails
    }
}