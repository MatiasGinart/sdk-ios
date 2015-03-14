//
//  Currency.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 3/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

class Currency {
    
    var id : String
    var description : String
    var symbol : String
    var decimalPlaces : Int
    var decimalSeparator : Character
    var thousandsSeparator : Character
    
    init(id: String, description: String, symbol: String, decimalPlaces: Int, decimalSeparator: Character, thousandSeparator: Character) {
        self.id = id
        self.description = description
        self.symbol = symbol
        self.decimalPlaces = decimalPlaces
        self.decimalSeparator = decimalSeparator
        self.thousandsSeparator = thousandSeparator
    }
    
}