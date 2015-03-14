//
//  Payment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Payment {
    var binaryMode : Bool!
    var callForAuthorizeId : String!
    var captured : Bool!
    var card : Card!
    var currencyId : String!
    var dateApproved : NSDate!
    var dateCreated : NSDate!
    var dateLastUpdated : NSDate!
    var description : String!
    var externalReference : String!
    var feesDetails : [FeesDetail]!
    var id : Int!
    var installments : Int!
    var liveMode : Bool!
    var metadata : NSObject!
    var moneyReleaseDate : NSDate!
    var notificationUrl : String!
    var order : Order!
    var payer : Payer!
    var paymentMethodId : String!
    var paymentTypeId : String!
    var refunds : [Refund]!
    var statementDescriptor : String!
    var status : String!
    var statusDetail : String!
    var transactionAmount : Double!
    var transactionAmountRefunded : Double!
    var transactionDetails : TransactionDetails!
    
    init(){}
    
    class func fromJSON(json : NSDictionary) -> Payment {
        var payment : Payment = Payment()
        
        payment.id = json["id"] as Int!
        payment.binaryMode = JSON(json["binary_mode"]!).asBool
        payment.captured = JSON(json["captured"]!).asBool
        payment.currencyId = JSON(json["currency_id"]!).asString
        payment.moneyReleaseDate = getDateFromString(json["money_release_date"] as? String!)
        payment.dateCreated = getDateFromString(json["date_created"] as String!)
        payment.dateLastUpdated = getDateFromString(json["date_last_updated"] as String!)
        payment.dateApproved = getDateFromString(json["date_approved"] as String!)
        payment.description = JSON(json["description"]!).asString
        payment.externalReference = JSON(json["external_reference"]!).asString
        payment.installments = json["installments"] as Int!
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
        return payment
    }
    
    class func getDateFromString(string: String!) -> NSDate! {
        if string == nil {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateArr = split(string) {$0 == "T"}
        return dateFormatter.dateFromString(dateArr[0])
    }
}