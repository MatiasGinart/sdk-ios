//
//  String+Additions.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation

extension String {
	
	var localized: String {
		var bundle : NSBundle? = MercadoPago.getBundle()
		if bundle == nil {
			bundle = NSBundle.mainBundle()
		}
		return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
	}
	
    static public func isNullOrEmpty(value: String?) -> Bool
    {
        return value == nil || value!.isEmpty
    }
    
    static public func isDigitsOnly(a: String) -> Bool {
        if let n = a.toInt() {
            return true
        } else {
            return false
        }
    }
    
    subscript (i: Int) -> String {
        
        if count(self) > i {
            
            return String(Array(self)[i])
        }
        
        return ""
    }
    
    public func indexAt(theInt:Int)->String.Index {
        
        return advance(self.startIndex, theInt)
    }
}