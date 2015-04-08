//
//  MPSecurityCodeTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPSecurityCodeTableViewCell : ErrorTableViewCell {
    @IBOutlet weak private var securityCodeLabel: UILabel!
    @IBOutlet weak private var securityCodeInfoLabel: UILabel!
    @IBOutlet weak public var securityCodeTextField: UITextField!
    @IBOutlet weak private var securityCodeImageView: UIImageView!
    public var hasError : Bool = false
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required public override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func getSecurityCode() -> String! {
        return self.securityCodeTextField.text
    }
    
    public func fillWithPaymentMethod(pm : PaymentMethod) {
        self.securityCodeImageView.image = UIImage(named: "imgTc_" + pm.id, inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection: nil)
        if pm.id == "amex" {
            self.securityCodeInfoLabel.text = "4 números al frente de la tarjeta"
        } else {
            self.securityCodeInfoLabel.text = "Últimos 3 números al dorso de la tarjeta"
        }
        
    }
    
}