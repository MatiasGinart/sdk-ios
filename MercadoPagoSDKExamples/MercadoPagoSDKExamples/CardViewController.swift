//
//  CardViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class CardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, KeyboardDelegate {
	var publicKey : String?
	
	@IBOutlet weak var tableView : UITableView!
	var cardNumberCell : MPCardNumberTableViewCell!
	var expirationDateCell : MPExpirationDateTableViewCell!
	var cardholderNameCell : MPCardholderNameTableViewCell!
	var userIdCell : MPUserIdTableViewCell!
	var securityCodeCell : SimpleSecurityCodeTableViewCell!
	
	var paymentMethod : PaymentMethod!
	
	var hasError : Bool = false
	var loadingView : UILoadingView!
	
	var identificationType : IdentificationType?
	var identificationTypes : [IdentificationType]?
	
	var callback : ((token : Token?) -> Void)?
	
	var isKeyboardVisible : Bool?
	var inputsCells : NSMutableArray!
	
	init(merchantPublicKey: String, paymentMethod: PaymentMethod, callback: (token: Token?) -> Void) {
		super.init(nibName: "CardViewController", bundle: nil)
		self.publicKey = merchantPublicKey
		self.paymentMethod = paymentMethod
		self.callback = callback
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override func viewDidAppear(animated: Bool) {
		self.tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.loadingView = UILoadingView(frame: MercadoPago.screenBoundsFixedToPortraitOrientation(), text: "Cargando...".localized)
		self.view.addSubview(self.loadingView)
		self.title = "Datos de tu tarjeta".localized
		
		self.navigationItem.backBarButtonItem?.title = "Atrás"
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continuar".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
		
		var mercadoPago = MercadoPago(publicKey: self.publicKey!)
		mercadoPago.getIdentificationTypes({(identificationTypes: [IdentificationType]?) -> Void in
			self.identificationTypes = identificationTypes
			self.prepareTableView()
			self.tableView.reloadData()
			self.loadingView.removeFromSuperview()
			}, failure: { (error: NSError?) -> Void in
				self.prepareTableView()
				self.tableView.reloadData()
				self.loadingView.removeFromSuperview()
				self.userIdCell.hidden = true
			}
		)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
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
	
	@IBAction func submitForm() {
		self.view.addSubview(self.loadingView)
		let cardToken = CardToken(cardNumber: self.cardNumberCell.getCardNumber(), expirationMonth: self.expirationDateCell.getExpirationMonth(), expirationYear: self.expirationDateCell.getExpirationYear(), securityCode: self.securityCodeCell.getSecurityCode(), cardholderName: self.cardholderNameCell.getCardholderName(), docType: self.userIdCell.getUserIdType(), docNumber: self.userIdCell.getUserIdValue())
		if validateForm(cardToken) {
			createToken(cardToken)
		} else {
			self.loadingView.removeFromSuperview()
			self.hasError = true
			self.tableView.reloadData()
		}
	}
	
	func getIndexForObject(object: AnyObject) -> Int {
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
	
	func scrollToRow(indexPath: NSIndexPath) {
		self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
	}
	
	func focusAndScrollForIndex(index: Int) {
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
	
	func prev(object: AnyObject?) {
		if object != nil {
			var index = getIndexForObject(object!)
			if index >= 1 {
				focusAndScrollForIndex(index-1)
			}
		}
	}
	
	func next(object: AnyObject?) {
		if object != nil {
			var index = getIndexForObject(object!)
			if index < self.inputsCells.count - 1 {
				focusAndScrollForIndex(index+1)
			}
		}
	}
	
	func done(object: AnyObject?) {
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
	
	func prepareTableView() {
		
		self.inputsCells = NSMutableArray()
		
		var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
		self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as! MPCardNumberTableViewCell
		self.cardNumberCell.height = 55.0
		self.cardNumberCell.setIcon(self.paymentMethod._id)
		self.cardNumberCell._setSetting(self.paymentMethod.settings[0])
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
		
		var securityCodeNib = UINib(nibName: "SimpleSecurityCodeTableViewCell", bundle: nil)
		self.tableView.registerNib(securityCodeNib, forCellReuseIdentifier: "securityCodeCell")
		self.securityCodeCell = self.tableView.dequeueReusableCellWithIdentifier("securityCodeCell") as! SimpleSecurityCodeTableViewCell
		self.securityCodeCell.height = 55.0
		self.securityCodeCell.securityCodeTextField.inputAccessoryView = MPToolbar(prevEnabled: true, nextEnabled: false, delegate: self, textFieldContainer: self.securityCodeCell.securityCodeTextField)
		self.inputsCells.addObject([self.securityCodeCell.securityCodeTextField, self.securityCodeCell])

		self.tableView.delegate = self
		self.tableView.dataSource = self
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 2 ? 1 : 2
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
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
		} else if indexPath.section == 2 {
			return self.securityCodeCell
		}
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
		} else if indexPath.section == 2 {
			return self.securityCodeCell.getHeight()
		}
		return 55
	}
	
	override func viewDidLayoutSubviews() {
		if self.tableView.respondsToSelector(Selector("setSeparatorInset:")) {
			self.tableView.separatorInset = UIEdgeInsetsZero
		}
		
		if self.tableView.respondsToSelector(Selector("setSeparatorInset:")) {
			self.tableView.layoutMargins = UIEdgeInsetsZero
		}
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if cell.respondsToSelector(Selector("setSeparatorInset:")) {
			cell.separatorInset = UIEdgeInsetsZero
		}
		
		if cell.respondsToSelector(Selector("setSeparatorInset:")) {
			cell.layoutMargins = UIEdgeInsetsZero
		}
	}
	
	func validateForm(cardToken : CardToken) -> Bool {
		
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
		
		let errorSecurityCode = cardToken.validateSecurityCode()
		if errorSecurityCode != nil {
			self.securityCodeCell.setError(errorSecurityCode!.userInfo!["securityCode"] as? String)
			result = false
		} else {
			self.securityCodeCell.setError(nil)
		}
		
		return result
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		let cell = textField.superview?.superview as! UITableViewCell?
		self.tableView.scrollToRowAtIndexPath(self.tableView.indexPathForCell(cell!)!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
	
	func createToken(cardToken: CardToken) {
		let mercadoPago = MercadoPago(publicKey: self.publicKey!)
		mercadoPago.createNewCardToken(cardToken, success: { (token) -> Void in
			self.loadingView.removeFromSuperview()
			self.callback?(token: token)
			}, failure: nil)
	}
}
