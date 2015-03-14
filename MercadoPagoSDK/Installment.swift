//
//  Installment.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 6/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Installment {
    var issuer : Issuer!
    var payerCosts : [PayerCost]!
    var paymentMethodId : String!
    var paymentTypeId : String!
    
    class func fromJSON(json : NSDictionary) -> Installment {
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