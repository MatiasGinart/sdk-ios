//
//  PaymentTotalTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 13/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

public class PaymentTotalTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
	
	override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override public func awakeFromNib() {
        super.awakeFromNib()
		self.lblTotal.text = "Total".localized
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
