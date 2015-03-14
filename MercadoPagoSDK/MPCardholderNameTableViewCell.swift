//
//  MPCardholderNameTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPCardholderNameTableViewCell : UITableViewCell {
    @IBOutlet weak private var cardholderNameLabel: UILabel!
    @IBOutlet weak private var cardholderNameTextField: UITextField!
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
    
    func getCardholderName() -> String! {
        return self.cardholderNameTextField.text
    }
    
    func setHasError(hasError : Bool)
    {
        if hasError {
            self.cardholderNameLabel.textColor = UIColor.redColor()
        } else {
            self.cardholderNameLabel.textColor = UIColor.blackColor()
        }
        self.hasError = hasError
    }
    
    func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.cardholderNameTextField.delegate = delegate
    }
}