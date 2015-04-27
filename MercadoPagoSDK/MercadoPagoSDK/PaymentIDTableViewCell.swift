//
//  PaymentIDTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 13/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

public class PaymentIDTableViewCell: UITableViewCell {

    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
	
	override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override public func awakeFromNib() {
        super.awakeFromNib()
		self.lblTitle.text = "Operación".localized
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
