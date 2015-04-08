//
//  CurrenciesUtil.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 3/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class CurrenciesUtil {
 
    public class var currenciesList : [String: Currency] { return [
        "ARS" : Currency(id: "ARS", description: "Peso argentino", symbol: "$", decimalPlaces: 2, decimalSeparator: ",", thousandSeparator: "."),
        "BRL" : Currency(id: "BRL", description: "Real", symbol: "R$", decimalPlaces: 2, decimalSeparator: ",", thousandSeparator: "."),
        "CLP" : Currency(id: "CLP", description: "Peso chileno", symbol: "$", decimalPlaces: 2, decimalSeparator: ",", thousandSeparator: "."),
        "COP" : Currency(id: "COP", description: "Peso colombiano", symbol: "$", decimalPlaces: 2, decimalSeparator: ",", thousandSeparator: "."),
        "MXN" : Currency(id: "MXN", description: "Peso mexicano", symbol: "$", decimalPlaces: 2, decimalSeparator: ".", thousandSeparator: ","),
        "VEF" : Currency(id: "VEF", description: "Bolipublic var fuerte", symbol: "BsF", decimalPlaces: 2, decimalSeparator: ",", thousandSeparator: ".")
        ]}
 
    public class func formatNumber(amount: Double, currencyId: String) -> String? {
    
        // Get currency configuration
        let currency : Currency? = currenciesList[currencyId]
    
        if currency != nil {
    
            // Set formatters
            var formatter : NSNumberFormatter = NSNumberFormatter()
            formatter.decimalSeparator = String(currency!.decimalSeparator)
            formatter.groupingSeparator = String(currency!.thousandsSeparator)
            formatter.numberStyle = .CurrencyStyle
            formatter.maximumFractionDigits = currency!.decimalPlaces
            // return formatted string
            let number = amount as NSNumber
            return currency!.symbol + " " + formatter.stringFromNumber(number)!
        } else {
            return nil
        }
    }
}