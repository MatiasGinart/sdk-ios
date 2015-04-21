//
//  MPCardNumberTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPCardNumberTableViewCell : ErrorTableViewCell, UITextFieldDelegate {
    @IBOutlet weak private var cardNumberLabel: UILabel!
    @IBOutlet weak private var cardNumberImageView: UIImageView!
    @IBOutlet weak public var cardNumberTextField: UITextField!
    public var hasError : Bool = false
    public var setting : Setting!
    
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
    
    public func getCardNumber() -> String! {
        return self.cardNumberTextField.text.stringByReplacingOccurrencesOfString(" ", withString:"")
    }
    
    public func setIcon(pmId : String?) {
        if String.isNullOrEmpty(pmId) {
            self.cardNumberImageView.hidden = true
        } else {
            self.cardNumberImageView.image = UIImage(named: "icoTc_" + pmId!, inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
            self.cardNumberImageView.hidden = false
        }
    }
    
    public func setSetting(setting: Setting!) {
        self.setting = setting
        self.cardNumberTextField.delegate = self
    }
    
    public func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.cardNumberTextField.delegate = delegate
    }
    
    public func textField(textField: UITextField!,shouldChangeCharactersInRange range: NSRange,    replacementString string: String!) -> Bool {
        
        if !Regex("^[0-9]$").test(string) && string != "" {
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