//
//  Payment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Payment : NSObject {
    public var binaryMode : Bool!
    public var callForAuthorizeId : String!
    public var captured : Bool!
    public var card : Card!
    public var currencyId : String!
    public var dateApproved : NSDate!
    public var dateCreated : NSDate!
    public var dateLastUpdated : NSDate!
    public var _description : String!
    public var externalReference : String!
    public var feesDetails : [FeesDetail]!
    public var id : Int!
    public var installments : Int!
    public var liveMode : Bool!
    public var metadata : NSObject!
    public var moneyReleaseDate : NSDate!
    public var notificationUrl : String!
    public var order : Order!
    public var payer : Payer!
    public var paymentMethodId : String!
    public var paymentTypeId : String!
    public var refunds : [Refund]!
    public var statementDescriptor : String!
    public var status : String!
    public var statusDetail : String!
    public var transactionAmount : Double!
    public var transactionAmountRefunded : Double!
    public var transactionDetails : TransactionDetails!
    public var collectorId : String!
    public var couponAmount : Double!
    public var differentialPricingId : Int64!
    public var issuerId : Int!
    
    public class func fromJSON(json : NSDictionary) -> Payment {
        var payment : Payment = Payment()
        
        payment.id = json["id"] as? Int
        if json["binary_mode"] != nil {
            payment.binaryMode = JSON(json["binary_mode"]!).asBool
        }
        if json["captured"] != nil {
            payment.captured = JSON(json["captured"]!).asBool
        }
        
        payment.currencyId = JSON(json["currency_id"]!).asString
        payment.moneyReleaseDate = getDateFromString(json["money_release_date"] as? String)
        payment.dateCreated = getDateFromString(json["date_created"] as? String)
        payment.dateLastUpdated = getDateFromString(json["date_last_updated"] as? String)
        payment.dateApproved = getDateFromString(json["date_approved"] as? String)
        payment._description = JSON(json["description"]!).asString
        payment.externalReference = JSON(json["external_reference"]!).asString
        payment.installments = json["installments"] as? Int
        payment.liveMode = JSON(json["live_mode"]!).asBool
        payment.notificationUrl = JSON(json["notification_url"]!).asString
        var feesDetails : [FeesDetail] = [FeesDetail]()
        if let feesDetailsArray = json["fee_details"] as? NSArray {
            for i in 0..<feesDetailsArray.count {
                if let feedDic = feesDetailsArray[i] as? NSDictionary {
                    feesDetails.append(FeesDetail.fromJSON(feedDic))
                }
            }
        }
        payment.feesDetails = feesDetails
        if let cardDic = json["card"] as? NSDictionary {
            payment.card = Card.fromJSON(cardDic)
        }
        if let orderDic = json["order"] as? NSDictionary {
            payment.order = Order.fromJSON(orderDic)
        }
        if let payerDic = json["payer"] as? NSDictionary {
            payment.payer = Payer.fromJSON(payerDic)
        }
        payment.paymentMethodId = JSON(json["payment_method_id"]!).asString
        payment.paymentTypeId = JSON(json["payment_type_id"]!).asString
        var refunds : [Refund] = [Refund]()
        if let refArray = json["refunds"] as? NSArray {
            for i in 0..<refArray.count {
                if let refDic = refArray[i] as? NSDictionary {
                    refunds.append(Refund.fromJSON(refDic))
                }
            }
        }
        payment.refunds = refunds
        payment.statementDescriptor = JSON(json["statement_descriptor"]!).asString
        payment.status = JSON(json["status"]!).asString
        payment.statusDetail = JSON(json["status_detail"]!).asString
        payment.transactionAmount = JSON(json["transaction_amount"]!).asDouble
        payment.transactionAmountRefunded = JSON(json["transaction_amount_refunded"]!).asDouble
        if let tdDic = json["transaction_details"] as? NSDictionary {
            payment.transactionDetails = TransactionDetails.fromJSON(tdDic)
        }
        payment.collectorId = json["collector_id"] as? String
        payment.couponAmount = json["coupon_amount"] as? Double
        payment.differentialPricingId = (json["differential_pricing_id"] as? NSNumber)?.longLongValue
        payment.issuerId = json["issuer_id"] as? Int
        return payment
    }
    
    public class func getDateFromString(string: String!) -> NSDate! {
        if string == nil {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateArr = split(string) {$0 == "T"}
        return dateFormatter.dateFromString(dateArr[0])
    }
}