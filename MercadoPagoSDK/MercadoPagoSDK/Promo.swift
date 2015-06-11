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
	public var recommendedMessage : String!
	public var paymentMethods : [PaymentMethod]!
	public var legals : String!
	public var url : String!
	
	public class func fromJSON(json : NSDictionary) -> Promo {
		
		var promo : Promo = Promo()
		promo.promoId = json["id"] as? String
		
		if let issuerDic = json["issuer"] as? NSDictionary {
			promo.issuer = Issuer.fromJSON(issuerDic)
		}

		promo.recommendedMessage = json["recommended_message"] as? String
		
		if let picDic = json["picture"] as? NSDictionary {
			promo.url = picDic["url"] as? String
		}
		
		var paymentMethods : [PaymentMethod] = [PaymentMethod]()
		if let pmArray = json["payment_methods"] as? NSArray {
			for i in 0..<pmArray.count {
				if let pmDic = pmArray[i] as? NSDictionary {
					paymentMethods.append(PaymentMethod.fromJSON(pmDic))
				}
			}
		}
		
		promo.paymentMethods = paymentMethods
		
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