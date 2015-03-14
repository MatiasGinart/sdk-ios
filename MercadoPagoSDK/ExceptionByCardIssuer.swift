//
//  ExceptionByCardIssuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class ExceptionByCardIssuer {
    var cardIssuer : CardIssuer
    var labels : [String]
    var thumbnail : String
    var secureThumbnail : String
    var totalFinancialCost : Double
    var acceptedBins : [Int]
    var payerCosts : [PayerCost]
    
    init (cardIssuer : CardIssuer, labels : [String], thumbnail : String,
        secureThumbnail : String, totalFinancialCost : Double,
        acceptedBins : [Int], payerCosts : [PayerCost]) {
        self.cardIssuer = cardIssuer
        self.labels = labels
        self.thumbnail = thumbnail
        self.secureThumbnail = secureThumbnail
        self.totalFinancialCost = totalFinancialCost
        self.acceptedBins = acceptedBins
        self.payerCosts = payerCosts
    }
}