//
//  MPPaymentMethodEmptyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 27/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class MPPaymentMethodEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak private var cardTextLabel : UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
}
