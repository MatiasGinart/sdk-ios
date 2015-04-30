//
//  SimpleSecurityCodeTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class SimpleSecurityCodeTableViewCell: ErrorTableViewCell {
    @IBOutlet weak private var securityCodeLabel: UILabel!
    @IBOutlet weak var securityCodeTextField: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
		self.securityCodeLabel.text = "security_code".localized
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getSecurityCode() -> String! {
        return self.securityCodeTextField.text
    }
    
    func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.securityCodeTextField.delegate = delegate
    }
}
