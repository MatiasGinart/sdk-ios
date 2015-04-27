//
//  MPInstallmentsTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPInstallmentsTableViewCell : UITableViewCell {
    @IBOutlet weak private var rowTitle : UILabel!
    @IBOutlet weak private var installmentsLabel : UILabel!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
		self.rowTitle.text = "Cuotas".localized
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func fillWithPayerCost(payerCost : PayerCost?, amount: Double) {
        if payerCost == nil {
            installmentsLabel.text = "Selecciona la cantidad de cuotas".localized
            installmentsLabel.textColor = UIColor.blackColor()
        } else {
            installmentsLabel.text = payerCost!.recommendedMessage
            installmentsLabel.textColor = UIColor.installments(UIColor.greenColor())()
        }
    }
}
