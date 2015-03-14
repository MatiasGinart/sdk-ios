//
//  SimpleSecurityCodeTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class SimpleSecurityCodeTableViewCell: UITableViewCell {
    @IBOutlet weak private var securityCodeLabel: UILabel!
    @IBOutlet weak var securityCodeTextField: UITextField!
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
   
    func setHasError(hasError : Bool)
    {
        if hasError {
            self.securityCodeLabel.textColor = UIColor.redColor()
        } else {
            self.securityCodeLabel.textColor = UIColor.blackColor()
        }
        self.hasError = hasError
    }
    
    func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.securityCodeTextField.delegate = delegate
    }
}
