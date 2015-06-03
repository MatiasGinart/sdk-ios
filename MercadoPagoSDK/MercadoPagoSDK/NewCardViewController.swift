//
//  NewCardViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class NewCardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, KeyboardDelegate {
    
    // ViewController parameters
    var key : String?
    var keyType : String?
    var paymentMethod: PaymentMethod?
    var requireSecurityCode : Bool?
    var callback: ((cardToken: CardToken) -> Void)?
    var identificationType : IdentificationType?
    var identificationTypes : [IdentificationType]?
    
    var bundle : NSBundle? = MercadoPago.getBundle()
    
    // Input controls
    @IBOutlet weak private var tableView : UITableView!
    var cardNumberCell : MPCardNumberTableViewCell!
    var expirationDateCell : MPExpirationDateTableViewCell!
    var cardholderNameCell : MPCardholderNameTableViewCell!
    var userIdCell : MPUserIdTableViewCell!
    var securityCodeCell : MPSecurityCodeTableViewCell!
    var hasError : Bool = false
    var loadingView : UILoadingView!
	
	var inputsCells : NSMutableArray!
	
    init(keyType: String, key: String, paymentMethod: PaymentMethod, requireSecurityCode: Bool, callback: ((cardToken: CardToken) -> Void)?) {
        super.init(nibName: "NewCardViewController", bundle: bundle)
        self.paymentMethod = paymentMethod
        self.requireSecurityCode = requireSecurityCode
        self.key = key
        self.keyType = keyType
        self.callback = callback
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
		
        self.loadingView = UILoadingView(frame: MercadoPago.screenBoundsFixedToPortraitOrientation(), text: "Cargando...".localized)
        
        self.title = "Datos de tu tarjeta".localized
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás".localized, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continuar".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
		
		self.view.addSubview(self.loadingView)
        var mercadoPago : MercadoPago
        mercadoPago = MercadoPago(keyType: self.keyType, key: self.key)
        mercadoPago.getIdentificationTypes({(identificationTypes: [IdentificationType]?) -> Void in
            self.identificationTypes = identificationTypes
            self.prepareTableView()
            self.tableView.reloadData()
            self.loadingView.removeFromSuperview()
            }, failure: { (error: NSError?) -> Void in
                
                if error?.code == MercadoPago.ERROR_API_CODE {
                    self.prepareTableView()
                    self.tableView.reloadData()
                    self.loadingView.removeFromSuperview()
                    self.userIdCell.hidden = true
                }
            }
        )
        
    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func willHideKeyboard(notification: NSNotification) {
		// resize content insets.
		let contentInsets = UIEdgeInsetsMake(64, 0.0, 0.0, 0)
		self.tableView.contentInset = contentInsets
		self.tableView.scrollIndicatorInsets = contentInsets
	}
	
	func willShowKeyboard(notification: NSNotification) {
		let s:NSValue? = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)
		var keyboardBounds :CGRect = s!.CGRectValue()
		
		// resize content insets.
		let contentInsets = UIEdgeInsetsMake(64, 0.0, keyboardBounds.size.height, 0)
		self.tableView.contentInset = contentInsets
		self.tableView.scrollIndicatorInsets = contentInsets
	}
	
	public func getIndexForObject(object: AnyObject) -> Int {
		var i = 0
		for arr in self.inputsCells {
			if let input = object as? UITextField {
				if let arrTextField = arr[0] as? UITextField {
					if input == arrTextField {
						return i
					}
				}
			}
			i++
		}
		return -1
	}
	
	public func scrollToRow(indexPath: NSIndexPath) {
		self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
	}
	
	public func focusAndScrollForIndex(index: Int) {
		let textField = self.inputsCells[index][0] as? UITextField!
		let cell = self.inputsCells[index][1] as? ErrorTableViewCell!
		if textField != nil {
			if !textField!.isFirstResponder() {
				textField!.becomeFirstResponder()
			}
		}
		if cell != nil {
			let indexPath = self.tableView.indexPathForCell(cell!)
			if indexPath != nil {
				scrollToRow(indexPath!)
			}
		}
	}
	
	public func prev(object: AnyObject?) {
		if object != nil {
			var index = getIndexForObject(object!)
			if index >= 1 {
				focusAndScrollForIndex(index-1)
			}
		}
	}
	
	public func next(object: AnyObject?) {
		if object != nil {
			var index = getIndexForObject(object!)
			if index < self.inputsCells.count - 1 {
				focusAndScrollForIndex(index+1)
			}
		}
	}
	
	public func done(object: AnyObject?) {
		if object != nil {
			var index = getIndexForObject(object!)
			if index < self.inputsCells.count {
				let textField = self.inputsCells[index][0] as? UITextField!
				let cell = self.inputsCells[index][1] as? ErrorTableViewCell!
				if textField != nil {
					textField!.resignFirstResponder()
				}
				let indexPath = NSIndexPath(forRow: 0, inSection: 0)
				scrollToRow(indexPath!)
			}
		}
	}
	
    public func prepareTableView() {
		self.inputsCells = NSMutableArray()
		
		var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
		self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as! MPCardNumberTableViewCell
		self.cardNumberCell.height = 55.0
		if self.paymentMethod != nil {
			self.cardNumberCell.setIcon(self.paymentMethod!._id)
			self.cardNumberCell._setSetting(self.paymentMethod!.settings[0])
		}
		self.cardNumberCell.cardNumberTextField.inputAccessoryView = MPToolbar(prevEnabled: false, nextEnabled: true, delegate: self, textFieldContainer: self.cardNumberCell.cardNumberTextField)
		self.inputsCells.addObject([self.cardNumberCell.cardNumberTextField, self.cardNumberCell])
		
		var expirationDateNib = UINib(nibName: "MPExpirationDateTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(expirationDateNib, forCellReuseIdentifier: "expirationDateCell")
		self.expirationDateCell = self.tableView.dequeueReusableCellWithIdentifier("expirationDateCell") as! MPExpirationDateTableViewCell
		self.expirationDateCell.height = 55.0
		self.expirationDateCell.expirationDateTextField.inputAccessoryView = MPToolbar(prevEnabled: true, nextEnabled: true, delegate: self, textFieldContainer: self.expirationDateCell.expirationDateTextField)
		self.inputsCells.addObject([self.expirationDateCell.expirationDateTextField, self.expirationDateCell])
		
		var cardholderNameNib = UINib(nibName: "MPCardholderNameTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(cardholderNameNib, forCellReuseIdentifier: "cardholderNameCell")
		self.cardholderNameCell = self.tableView.dequeueReusableCellWithIdentifier("cardholderNameCell") as! MPCardholderNameTableViewCell
		self.cardholderNameCell.height = 55.0
		self.cardholderNameCell.cardholderNameTextField.inputAccessoryView = MPToolbar(prevEnabled: true, nextEnabled: true, delegate: self, textFieldContainer: self.cardholderNameCell.cardholderNameTextField)
		self.inputsCells.addObject([self.cardholderNameCell.cardholderNameTextField, self.cardholderNameCell])
		
		var userIdNib = UINib(nibName: "MPUserIdTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(userIdNib, forCellReuseIdentifier: "userIdCell")
		self.userIdCell = self.tableView.dequeueReusableCellWithIdentifier("userIdCell") as! MPUserIdTableViewCell
		self.userIdCell._setIdentificationTypes(self.identificationTypes)
		self.userIdCell.height = 55.0
		self.userIdCell.userIdTypeTextField.inputAccessoryView = MPToolbar(prevEnabled: true, nextEnabled: true, delegate: self, textFieldContainer: self.userIdCell.userIdTypeTextField)
		self.userIdCell.userIdValueTextField.inputAccessoryView = MPToolbar(prevEnabled: true, nextEnabled: true, delegate: self, textFieldContainer: self.userIdCell.userIdValueTextField)
		
		self.inputsCells.addObject([self.userIdCell.userIdTypeTextField, self.userIdCell])
		self.inputsCells.addObject([self.userIdCell.userIdValueTextField, self.userIdCell])
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
    }
    
    public func submitForm() {
        
        var cardToken = CardToken(cardNumber: self.cardNumberCell.getCardNumber(), expirationMonth: self.expirationDateCell.getExpirationMonth(), expirationYear: self.expirationDateCell.getExpirationYear(), securityCode: nil, cardholderName: self.cardholderNameCell.getCardholderName(), docType: self.userIdCell.getUserIdType(), docNumber: self.userIdCell.getUserIdValue())
        
        self.view.addSubview(self.loadingView)
        
        if validateForm(cardToken) {
            callback!(cardToken: cardToken)
        } else {
            self.hasError = true
            self.tableView.reloadData()
            self.loadingView.removeFromSuperview()
        }
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		if indexPath.section == 0 {
			if indexPath.row == 0 {
				return self.cardNumberCell
			} else if indexPath.row == 1 {
				return self.expirationDateCell
			}
		} else if indexPath.section == 1 {
			if indexPath.row == 0 {
				return self.cardholderNameCell
			} else if indexPath.row == 1 {
				return self.userIdCell
			}
		}
        return UITableViewCell()
    }
	
	override public func viewDidLayoutSubviews() {
		if self.tableView.respondsToSelector(Selector("setSeparatorInset:")) {
			self.tableView.separatorInset = UIEdgeInsetsZero
		}
		
		if self.tableView.respondsToSelector(Selector("setSeparatorInset:")) {
			self.tableView.layoutMargins = UIEdgeInsetsZero
		}
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if cell.respondsToSelector(Selector("setSeparatorInset:")) {
			cell.separatorInset = UIEdgeInsetsZero
		}
		
		if cell.respondsToSelector(Selector("setSeparatorInset:")) {
			cell.layoutMargins = UIEdgeInsetsZero
		}
	}
	
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				return self.cardNumberCell.getHeight()
			} else if indexPath.row == 1 {
				return self.expirationDateCell.getHeight()
			}
		} else if indexPath.section == 1 {
			if indexPath.row == 0 {
				return self.cardholderNameCell.getHeight()
			} else if indexPath.row == 1 {
				return self.userIdCell.getHeight()
			}
		}
        return 55
    }
    
    public func validateForm(cardToken : CardToken) -> Bool {
        
        var result : Bool = true
        var focusSet : Bool = false
        
        // Validate card number
        let errorCardNumber = cardToken.validateCardNumber(paymentMethod!)
        if  errorCardNumber != nil {
            self.cardNumberCell.setError(errorCardNumber!.userInfo!["cardNumber"] as? String)
            result = false
        } else {
            self.cardNumberCell.setError(nil)
        }
        
        // Validate expiry date
        let errorExpiryDate = cardToken.validateExpiryDate()
        if errorExpiryDate != nil {
            self.expirationDateCell.setError(errorExpiryDate!.userInfo!["expiryDate"] as? String)
            result = false
        } else {
            self.expirationDateCell.setError(nil)
        }

        // Validate card holder name
        let errorCardholder = cardToken.validateCardholderName()
        if errorCardholder != nil {
            self.cardholderNameCell.setError(errorCardholder!.userInfo!["cardholder"] as? String)
            result = false
        } else {
            self.cardholderNameCell.setError(nil)
        }
        
        // Validate identification number
        let errorIdentificationType = cardToken.validateIdentificationType()
        var errorIdentificationNumber : NSError? = nil
        if self.identificationType != nil {
            errorIdentificationNumber = cardToken.validateIdentificationNumber(self.identificationType!)
        } else {
            errorIdentificationNumber = cardToken.validateIdentificationNumber()
        }
        
        if errorIdentificationType != nil {
            self.userIdCell.setError(errorIdentificationType!.userInfo!["identification"] as? String)
            result = false
        } else if errorIdentificationNumber != nil {
            self.userIdCell.setError(errorIdentificationNumber!.userInfo!["identification"] as? String)
            result = false
        } else {
            self.userIdCell.setError(nil)
        }
        
        return result
    }
    
}