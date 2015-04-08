//
//  Installment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Installment : NSObject {
    public var issuer : Issuer!
    public var payerCosts : [PayerCost]!
    public var paymentMethodId : String!
    public var paymentTypeId : String!
    
    public class func fromJSON(json : NSDictionary) -> Installment {
        var installment : Installment = Installment()
        installment.paymentMethodId = JSON(json["payment_method_id"]!).asString
        installment.paymentTypeId = JSON(json["payment_type_id"]!).asString
        
        if let issuerDic = json["issuer"] as? NSDictionary {
            installment.issuer = Issuer.fromJSON(issuerDic)
        }
        
        var payerCosts : [PayerCost] = [PayerCost]()
        if let payerCostsArray = json["payer_costs"] as? NSArray {
            for i in 0..<payerCostsArray.count {
                if let payerCostDic = payerCostsArray[i] as? NSDictionary {
                    payerCosts.append(PayerCost.fromJSON(payerCostDic))
                }
            }
        }
        installment.payerCosts = payerCosts
        
        return installment
    }
    
}