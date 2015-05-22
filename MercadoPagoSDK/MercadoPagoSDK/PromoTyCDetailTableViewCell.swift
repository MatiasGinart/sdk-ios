//
//  PromoTyCDetailTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

public class PromoTyCDetailTableViewCell: UITableViewCell {

	@IBOutlet weak private var tycLabel: UILabel!
	
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	public func setLabelWithIssuerName(issuer: String, legals: String) {
		var s = NSMutableAttributedString(string: "\(issuer): \(legals)")
		let atts : [NSObject : AnyObject] = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 15)!]
		s.addAttributes(atts, range: NSMakeRange(0, count(issuer)))
		self.tycLabel.attributedText = s
	}
	
}
