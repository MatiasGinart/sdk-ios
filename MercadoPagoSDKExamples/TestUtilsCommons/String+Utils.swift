//
//  String+Utils.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

public extension String {
    public static func getCapitalizedStringOfString(string :String, withPrefix prefix :String) -> String? {
        if count(string) == 0 {
            return nil;
        }
        
        let firstLetterCapitalized = string.substringToIndex(advance(string.startIndex, 1)).capitalizedString
        let restOfString = string.substringFromIndex(advance(string.startIndex, 1))
        return prefix + firstLetterCapitalized + restOfString
    }
}
