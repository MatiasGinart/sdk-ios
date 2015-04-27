//
//  MPUserIdTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPUserIdTableViewCell : ErrorTableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak private var userIdTypeLabel: UILabel!
    @IBOutlet weak private var userIdValueLabel: UILabel!
    @IBOutlet weak private var userIdTypeTextField: UITextField!
    @IBOutlet weak private var userIdValueTextField: UITextField!
    
    @IBOutlet public var pickerIdentificationType: UIPickerView! = UIPickerView()
    
    public var identificationTypes : [IdentificationType] = [IdentificationType]()
    public var identificationType : IdentificationType?
	
	override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		pickerIdentificationType.hidden = true
	}
	
    // returns the number of 'columns' to display.
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return identificationTypes.count
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return identificationTypes[row].name
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        setFormWithIndex(row)
        pickerIdentificationType.hidden = true
        userIdTypeTextField.resignFirstResponder()
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.userIdTypeTextField {
            pickerIdentificationType.hidden = false
        }
        return true
    }
    
    public func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,    replacementString string: String) -> Bool {
        if textField == self.userIdValueTextField {
            
            if identificationType != nil && (((identificationType!.type! == "number" && !Regex("^[0-9]$").test(string)) ||
            (identificationType!.type! != "number" && Regex("^[0-9]$").test(string))) && string != "") {
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
    
    public func setFormWithIndex(row: Int) {
        identificationType = identificationTypes[row]
        if identificationType != nil && identificationType!.type! == "number" {
            userIdValueTextField.keyboardType = UIKeyboardType.NumberPad
        } else {
            userIdValueTextField.keyboardType = UIKeyboardType.Default
        }
        userIdTypeTextField.text = identificationTypes[row].name
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
		self.userIdTypeLabel.text = "Tipo".localized
		self.userIdValueLabel.text = "Documento".localized
        pickerIdentificationType = UIPickerView()
        pickerIdentificationType.delegate = self
        pickerIdentificationType.dataSource = self
        self.userIdTypeTextField.inputView = pickerIdentificationType
        self.userIdTypeTextField.delegate = self
        self.userIdValueTextField.delegate = self
    }
    
    public func _setIdentificationTypes(identificationTypes: [IdentificationType]?) {
        if identificationTypes != nil {
            self.identificationTypes = identificationTypes!
            setFormWithIndex(0)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pickerIdentificationType.hidden = true
    }
    
    public func getUserIdType() -> String! {
        return self.userIdTypeTextField.text
    }

    public func getUserIdValue() -> String! {
        return self.userIdValueTextField.text
    }
    
    public func setTextFieldDelegate(delegate : UITextFieldDelegate) {
        self.userIdValueTextField.delegate = delegate
    }
    
}