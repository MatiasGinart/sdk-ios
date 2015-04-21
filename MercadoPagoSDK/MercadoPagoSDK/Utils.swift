//
//  Utils.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 21/4/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

class Utils {
    class func getDateFromString(string: String!) -> NSDate! {
        if string == nil {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateArr = split(string) {$0 == "T"}
        return dateFormatter.dateFromString(dateArr[0])
    }
}