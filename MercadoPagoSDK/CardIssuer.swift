//
//  CardIssuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

class CardIssuer {
    var id : String
    var name : String?
    var labels : [String]
    
    init (id: String, name: String?, labels: [String]) {
        self.id = id
        self.name = name
        self.labels = labels
    }
}