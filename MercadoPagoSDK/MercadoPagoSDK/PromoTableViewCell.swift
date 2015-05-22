//
//  PromoTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

public class PromoTableViewCell: UITableViewCell {

	@IBOutlet weak public var issuerImageView: UIImageView!
	@IBOutlet weak public var sharesSubtitle: UILabel!
	@IBOutlet weak public var paymentMethodsSubtitle: UILabel!
	
	override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public func setPromoInfo(promo: Promo!) {
		var placeholderImage = "empty_tc"
		if promo != nil && promo!.issuer != nil && promo!.issuer!._id != nil {
			var imgURL: NSURL = NSURL(string: "http://static.mlstatic.com/org-img/MP/app/wallet/android/promos-bancos/ico_bank_\(promo!.issuer!._id!).png")!
			let request: NSURLRequest = NSURLRequest(URL: imgURL)
			NSURLConnection.sendAsynchronousRequest(
				request, queue: NSOperationQueue.mainQueue(),
				completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
					if error == nil {
						self.issuerImageView.image = UIImage(data: data)
					}
			})
		}

		self.sharesSubtitle.text = "\(promo.maxInstallments!) " + "cuotas sin interés".localized
		
		if promo!.paymentMethods != nil && promo!.paymentMethods!.count > 0 {
			if promo!.paymentMethods!.count == 1 {
				self.paymentMethodsSubtitle.text = promo!.paymentMethods[0].name
			} else {
				var s = ""
				var i = 0
				for pm in promo.paymentMethods {
					s = s + pm.name
					if i == promo.paymentMethods.count - 2 {
						s = s + " y ".localized
					} else if i < promo.paymentMethods.count - 1 {
						s = s + ", "
					}
					i = i + 1
				}
				self.paymentMethodsSubtitle.text = s
			}
		} else {
			self.paymentMethodsSubtitle.text = ""
		}
	}
}
