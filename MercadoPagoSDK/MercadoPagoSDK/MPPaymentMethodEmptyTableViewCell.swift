//
//  MPPaymentMethodEmptyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 27/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

public class MPPaymentMethodEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak private var cardTextLabel : UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
		cardTextLabel.text = "Selecciona un medio de pago...".localized
		titleLabel.text = "Medio de pago".localized
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
