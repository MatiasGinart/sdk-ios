//
//  MPExpirationDateTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPExpirationDateTableViewCell : ErrorTableViewCell, UITextFieldDelegate {
    @IBOutlet weak private var expirationDateLabel: UILabel!
    @IBOutlet weak private var expirationDateTextField: UITextField!
    public var hasError : Bool = false
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.expirationDateTextField.delegate = self
        self.expirationDateTextField.keyboardType = UIKeyboardType.NumberPad
    }
    
    required public override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func getExpirationMonth() -> Int? {
        if String.isNullOrEmpty(self.expirationDateTextField.text) {
            return nil
        }
        
        var monthStr = split(self.expirationDateTextField.text!) {$0 == "/"}[0] as NSString
        monthStr = monthStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return monthStr.integerValue
    }
    
    public func getExpirationYear() -> Int? {
        if String.isNullOrEmpty(self.expirationDateTextField.text) {
            return nil
        }
        
        var yearStr = split(self.expirationDateTextField.text!) {$0 == "/"}[1] as NSString
        yearStr = yearStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return yearStr.integerValue
    }
    
    public func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.expirationDateTextField.delegate = delegate
    }
    
    public func textField(textField: UITextField!,shouldChangeCharactersInRange range: NSRange,    replacementString string: String!) -> Bool {
        
        if !Regex("^[0-9]$").test(string) {
            return false
        }
        
        var txtAfterUpdate:NSString = textField.text as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        if txtAfterUpdate.length <= 7 {
            let date : NSString = txtAfterUpdate.stringByReplacingOccurrencesOfString(" / ", withString:"")
            if date.length > 2 {
                var mutableString : NSMutableString = NSMutableString(capacity: date.length + 1)
                for i in 0...(date.length-1) {
                    if i == 2 {
                        mutableString.appendFormat(" / %C", date.characterAtIndex(i))
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