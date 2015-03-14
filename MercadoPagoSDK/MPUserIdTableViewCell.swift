//
//  MPUserIdTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPUserIdTableViewCell : UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak private var userIdTypeLabel: UILabel!
    @IBOutlet weak private var userIdValueLabel: UILabel!
    @IBOutlet weak private var userIdTypeTextField: UITextField!
    @IBOutlet weak private var userIdValueTextField: UITextField!
    
    @IBOutlet var pickerIdentificationType: UIPickerView! = UIPickerView()
    
    var identificationTypes : [IdentificationType] = [IdentificationType]()
    var identificationType : IdentificationType?
   
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return identificationTypes.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return identificationTypes[row].name
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        setFormWithIndex(row)
        pickerIdentificationType.hidden = true
        userIdTypeTextField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.userIdTypeTextField {
            pickerIdentificationType.hidden = false
        }
        return true
    }
    
    func textField(textField: UITextField!,shouldChangeCharactersInRange range: NSRange,    replacementString string: String!) -> Bool {
        if textField == self.userIdValueTextField {
            
            if (identificationType?.type? == "number" && !Regex("^[0-9]$").test(string)) ||
            (identificationType?.type? != "number" && Regex("^[0-9]$").test(string)){
                return false
            }
            var txtAfterUpdate:NSString = textField.text as NSString
            txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
            if txtAfterUpdate.length <= self.identificationType?.maxLength {
                    return true
            }
            return false
        }
        return false
    }
    
    var hasError : Bool = false
    
    func setFormWithIndex(row: Int) {
        identificationType = identificationTypes[row]
        if identificationType?.type? == "number" {
            userIdValueTextField.keyboardType = UIKeyboardType.NumberPad
        } else {
            userIdValueTextField.keyboardType = UIKeyboardType.Default
        }
        userIdTypeTextField.text = identificationTypes[row].name
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        pickerIdentificationType.hidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerIdentificationType = UIPickerView()
        pickerIdentificationType.delegate = self
        pickerIdentificationType.dataSource = self
        self.userIdTypeTextField.inputView = pickerIdentificationType
        self.userIdTypeTextField.delegate = self
        self.userIdValueTextField.delegate = self
    }
    
    func setIdentificationTypes(identificationTypes: [IdentificationType]?) {
        if identificationTypes != nil {
            self.identificationTypes = identificationTypes!
            setFormWithIndex(0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pickerIdentificationType.hidden = true
    }
    
    func getUserIdType() -> String! {
        return self.userIdTypeTextField.text
    }

    func getUserIdValue() -> String! {
        return self.userIdValueTextField.text
    }
    
    func setHasError(hasError : Bool)
    {
        if hasError {
            self.userIdTypeLabel.textColor = UIColor.redColor()
            self.userIdValueLabel.textColor = UIColor.redColor()
        } else {
            self.userIdTypeLabel.textColor = UIColor.blackColor()
            self.userIdValueLabel.textColor = UIColor.blackColor()
        }
        self.hasError = hasError
    }
    
    func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.userIdValueTextField.delegate = delegate
    }
    
}