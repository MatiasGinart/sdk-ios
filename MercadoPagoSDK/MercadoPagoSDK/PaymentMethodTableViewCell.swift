//
//  PaymentMethodTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class PaymentMethodTableViewCell : UITableViewCell {
    @IBOutlet private weak var paymentMethodLabel : UILabel!
    @IBOutlet private var paymentMethodImage : UIImageView!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setLabel(label : String) {
        self.paymentMethodLabel.text = label
    }

    public func setImageWithName(imageName : String) {
        self.paymentMethodImage.image = UIImage(named: imageName, inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection: nil)
    }
}