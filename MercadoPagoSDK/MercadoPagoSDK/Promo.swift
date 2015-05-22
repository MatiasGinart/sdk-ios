//
//  Promo.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

public class Promo {
	
	public var promoId : String!
	public var issuer : Issuer!
	public var maxInstallments : NSNumber!
	public var marketplace : String!
	public var startDate : NSDate!
	public var expirationDate : NSDate!
	public var paymentMethods : [PaymentMethod]!
	public var legals : String!
	
	public class func fromJSON(json : NSDictionary) -> Promo {
		
		var promo : Promo = Promo()
		promo.promoId = json["id"] as? String
		
		if let issuerDic = json["issuer"] as? NSDictionary {
			promo.issuer = Issuer.fromJSON(issuerDic)
		}
		
		promo.maxInstallments = json["max_installments"] as? NSNumber
		promo.startDate = getDateFromString(json["start_date"] as? String)
		promo.expirationDate = getDateFromString(json["expiration_date"] as? String)
		
		var paymentMethods : [PaymentMethod] = [PaymentMethod]()
		if let pmArray = json["payment_methods"] as? NSArray {
			for i in 0..<pmArray.count {
				if let pmDic = pmArray[i] as? NSDictionary {
					paymentMethods.append(PaymentMethod.fromJSON(pmDic))
				}
			}
		}
		
		promo.paymentMethods = paymentMethods
		
		promo.marketplace = json["marketplace"] as? String
		promo.legals = json["legals"] as? String
		
		return promo
	}
	
	public class func getDateFromString(string: String!) -> NSDate! {
		if string == nil {
			return nil
		}
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		var dateArr = split(string) {$0 == "T"}
		return dateFormatter.dateFromString(dateArr[0])
	}
}