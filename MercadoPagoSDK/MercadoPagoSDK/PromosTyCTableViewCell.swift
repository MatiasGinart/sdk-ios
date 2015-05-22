//
//  PromosTyCTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

public class PromosTyCTableViewCell: UITableViewCell {

	@IBOutlet weak private var title: UILabel!
	
    override public func awakeFromNib() {
        super.awakeFromNib()
		self.title.text = "Términos y condiciones".localized
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
