//
//  MPExpirationDateTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPExpirationDateTableViewCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak private var expirationDateLabel: UILabel!
    @IBOutlet weak private var expirationDateTextField: UITextField!
    var hasError : Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.expirationDateTextField.delegate = self
        self.expirationDateTextField.keyboardType = UIKeyboardType.NumberPad
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getExpirationMonth() -> Int? {
        if String.isNullOrEmpty(self.expirationDateTextField.text) {
            return nil
        }
         return split(self.expirationDateTextField.text!) {$0 == "/"}[0].toInt()
    }
    
    func getExpirationYear() -> Int? {
        if String.isNullOrEmpty(self.expirationDateTextField.text) {
            return nil
        }
        return split(self.expirationDateTextField.text!) {$0 == "/"}[1].toInt()
    }
    
    func setHasError(hasError : Bool)
    {
        if hasError {
            self.expirationDateLabel.textColor = UIColor.redColor()
        } else {
            self.expirationDateLabel.textColor = UIColor.blackColor()
        }
        self.hasError = hasError
    }
    
    func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.expirationDateTextField.delegate = delegate
    }
    
    func textField(textField: UITextField!,shouldChangeCharactersInRange range: NSRange,    replacementString string: String!) -> Bool {
        
        if !Regex("^[0-9]$").test(string) {
            return false
        }
        
        var txtAfterUpdate:NSString = textField.text as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        if txtAfterUpdate.length <= 5 {
            let date : NSString = txtAfterUpdate.stringByReplacingOccurrencesOfString("/", withString:"")
            if date.length > 2 {
                var mutableString : NSMutableString = NSMutableString(capacity: date.length + 1)
                for i in 0...(date.length-1) {
                    if i == 2 {
                        mutableString.appendFormat("/%C", date.characterAtIndex(i))
                    } else {
                        mutableString.appendFormat("%C", date.characterAtIndex(i))
                    }
                }
                self.expirationDateTextField.text = mutableString
                return false
            }
            return true
        }
        return false
    }
}