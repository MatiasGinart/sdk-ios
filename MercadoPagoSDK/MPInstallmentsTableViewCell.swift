//
//  MPInstallmentsTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPInstallmentsTableViewCell : UITableViewCell {
    @IBOutlet weak private var rowTitle : UILabel!
    @IBOutlet weak private var installmentsLabel : UILabel!
    
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
    
    func fillWithPayerCost(payerCost : PayerCost?, amount: Double) {
        if payerCost == nil {
            installmentsLabel.text = "Seleccione la cantidad de cuotas"
            installmentsLabel.textColor = UIColor.blackColor()
        } else {
            installmentsLabel.text = payerCost!.recommendedMessage
            installmentsLabel.textColor = UIColor.installments(UIColor.greenColor())()
        }
    }
}
