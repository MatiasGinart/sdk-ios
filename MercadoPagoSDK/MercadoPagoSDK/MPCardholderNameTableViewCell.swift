//
//  MPCardholderNameTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPCardholderNameTableViewCell : ErrorTableViewCell {
    @IBOutlet weak private var cardholderNameLabel: UILabel!
    @IBOutlet weak private var cardholderNameTextField: UITextField!
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
    
    
    public func getCardholderName() -> String! {
        return self.cardholderNameTextField.text
    }
    
    public func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.cardholderNameTextField.delegate = delegate
    }
}