//
//  MPCardNumberTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPCardNumberTableViewCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak private var cardNumberLabel: UILabel!
    @IBOutlet weak private var cardNumberImageView: UIImageView!
    @IBOutlet weak private var cardNumberTextField: UITextField!
    var hasError : Bool = false
    var setting : Setting!
    
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
    
    func getCardNumber() -> String! {
        return self.cardNumberTextField.text.stringByReplacingOccurrencesOfString(" ", withString:"")
    }
    
    func setHasError(hasError : Bool)
    {
        if hasError {
            self.cardNumberLabel.textColor = UIColor.redColor()
        } else {
            self.cardNumberLabel.textColor = UIColor.blackColor()
        }
        self.hasError = hasError
    }
    
    func setIcon(pmId : String?) {
        if String.isNullOrEmpty(pmId) {
            self.cardNumberImageView.hidden = true
        } else {
            self.cardNumberImageView.image = UIImage(named: "icoTc_" + pmId!)
            self.cardNumberImageView.hidden = false
        }
    }
    
    func setSetting(setting: Setting!) {
        self.setting = setting
        self.cardNumberTextField.delegate = self
    }
    
    func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.cardNumberTextField.delegate = delegate
    }
    
    func textField(textField: UITextField!,shouldChangeCharactersInRange range: NSRange,    replacementString string: String!) -> Bool {
        
        if !Regex("^[0-9]$").test(string) {
            return false
        }
        
        var maxLength = 16
        var spaces = 3
        maxLength = self.setting.cardNumber!.length
        if maxLength == 15 {
            spaces = 2
        }
        
        var txtAfterUpdate:NSString = textField.text as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        if txtAfterUpdate.length <= maxLength+spaces {
            if txtAfterUpdate.length > 4 {
                let cardNumber : NSString = txtAfterUpdate.stringByReplacingOccurrencesOfString(" ", withString:"")
                if maxLength == 16 {
                    // 4 4 4 4
                    var mutableString : NSMutableString = NSMutableString(capacity: maxLength + spaces)
                    for i in 0...(cardNumber.length-1) {
                        if i > 0 && i%4 == 0 {
                            mutableString.appendFormat(" %C", cardNumber.characterAtIndex(i))
                        } else {
                            mutableString.appendFormat("%C", cardNumber.characterAtIndex(i))
                        }
                    }
                    self.cardNumberTextField.text = mutableString
                    return false
                } else if maxLength == 15 {
                    // 4 6 5
                    var mutableString : NSMutableString = NSMutableString(capacity: maxLength + spaces)
                    for i in 0...(cardNumber.length-1) {
                        if i == 4 || i == 10 {
                            mutableString.appendFormat(" %C", cardNumber.characterAtIndex(i))
                        } else {
                            mutableString.appendFormat("%C", cardNumber.characterAtIndex(i))
                        }
                    }
                    self.cardNumberTextField.text = mutableString
                    return false
                }
            }
            return true
        }
        return false
    }
    
}