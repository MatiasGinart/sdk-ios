//
//  Regex.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation

public class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
    }
    
    public func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count > 0
    }
}
