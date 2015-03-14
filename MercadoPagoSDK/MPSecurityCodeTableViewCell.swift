//
//  MPSecurityCodeTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPSecurityCodeTableViewCell : UITableViewCell {
    @IBOutlet weak private var securityCodeLabel: UILabel!
    @IBOutlet weak private var securityCodeInfoLabel: UILabel!
    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak private var securityCodeImageView: UIImageView!
    var hasError : Bool = false
    
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
    
    func getSecurityCode() -> String! {
        return self.securityCodeTextField.text
    }
    
    func fillWithPaymentMethod(pm : PaymentMethod) {
        self.securityCodeImageView.image = UIImage(named: "imgTc_" + pm.id)
        if pm.id == "amex" {
            self.securityCodeInfoLabel.text = "4 números al frente de la tarjeta"
        } else {
            self.securityCodeInfoLabel.text = "Últimos 3 números al dorso de la tarjeta"
        }
        
    }
    
    func setHasError(hasError : Bool)
    {
        if hasError {
            self.securityCodeLabel.textColor = UIColor.redColor()
        } else {
            self.securityCodeLabel.textColor = UIColor.blackColor()
        }
        self.hasError = hasError
    }
}