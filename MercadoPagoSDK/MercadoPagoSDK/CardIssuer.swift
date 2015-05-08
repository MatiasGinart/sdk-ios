//
//  CardIssuer.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

public class CardIssuer : NSObject {
    public var _id : String!
    public var name : String!
    public var labels : [String]!
    
    public init (_id: String, name: String?, labels: [String]) {
        super.init()
        self._id = _id
        self.name = name
        self.labels = labels
    }
}