//
//  InstallmentTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class InstallmentTableViewCell : UITableViewCell {
    @IBOutlet private weak var installmentsLabel : UILabel!
    
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
    
    public func fillWithPayerCost(payerCost : PayerCost, amount: Double) {
        installmentsLabel.text = payerCost.recommendedMessage
    }
}
