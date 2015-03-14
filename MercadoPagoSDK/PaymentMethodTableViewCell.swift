//
//  PaymentMethodTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class PaymentMethodTableViewCell : UITableViewCell {
    @IBOutlet private weak var paymentMethodLabel : UILabel!
    @IBOutlet private var paymentMethodImage : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLabel(label : String) {
        self.paymentMethodLabel.text = label
    }

    func setImageWithName(imageName : String) {
        self.paymentMethodImage.image = UIImage(named:imageName)
    }
}