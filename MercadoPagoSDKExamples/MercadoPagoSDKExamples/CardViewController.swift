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
		
		IQKeyboardManager.sharedManager().enable = true
		IQKeyboardManager.sharedManager().enableAutoToolbar = true
		
		self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...".localized)
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
	
	func prev(object: AnyObject) {
		if let cell = object as? MPExpirationDateTableViewCell {
			self.cardNumberCell.focus()
		} else if let cell = object as? MPCardholderNameTableViewCell {
			self.expirationDateCell.focus()
		} else if let cell = object as? MPUserIdTableViewCell {
			self.cardholderNameCell.focus()
		} else if let cell = object as? SimpleSecurityCodeTableViewCell {
			self.userIdCell.focus()
		}
	}
	
	func next(object: AnyObject) {
		if let cell = object as? MPCardNumberTableViewCell {
			self.expirationDateCell.focus()
		} else if let cell = object as? MPExpirationDateTableViewCell {
			self.cardholderNameCell.focus()
		} else if let cell = object as? MPCardholderNameTableViewCell {
			self.userIdCell.focus()
		} else if let cell = object as? MPUserIdTableViewCell {
			self.securityCodeCell.focus()
		}
	}
	
	func done(object: AnyObject) {
		if let cell = object as? MPCardNumberTableViewCell {
			self.cardNumberCell.cardNumberTextField.resignFirstResponder()
		} else if let cell = object as? MPExpirationDateTableViewCell {
			self.expirationDateCell.expirationDateTextField.resignFirstResponder()
		} else if let cell = object as? MPCardholderNameTableViewCell {
			self.cardholderNameCell.cardholderNameTextField.resignFirstResponder()
		} else if let cell = object as? MPUserIdTableViewCell {
			self.userIdCell.userIdValueTextField.resignFirstResponder()
			self.userIdCell.userIdTypeTextField.resignFirstResponder()
		}else if let cell = object as? SimpleSecurityCodeTableViewCell {
			self.securityCodeCell.securityCodeTextField.resignFirstResponder()
		}
	}
	
	
	func prepareTableView() {
		
		var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
		self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as! MPCardNumberTableViewCell
		self.cardNumberCell.height = 55.0
		self.cardNumberCell.setIcon(self.paymentMethod._id)
		self.cardNumberCell._setSetting(self.paymentMethod.settings[0])
		self.cardNumberCell.keyboardDelegate = self
		self.cardNumberCell.cardNumberTextField.setEnablePrevious(false, isNextEnabled: true)
		
		var expirationDateNib = UINib(nibName: "MPExpirationDateTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(expirationDateNib, forCellReuseIdentifier: "expirationDateCell")
		self.expirationDateCell = self.tableView.dequeueReusableCellWithIdentifier("expirationDateCell") as! MPExpirationDateTableViewCell
		self.expirationDateCell.height = 55.0
		self.expirationDateCell.keyboardDelegate = self
		self.expirationDateCell.expirationDateTextField.setEnablePrevious(true, isNextEnabled: true)
		
		var cardholderNameNib = UINib(nibName: "MPCardholderNameTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(cardholderNameNib, forCellReuseIdentifier: "cardholderNameCell")
		self.cardholderNameCell = self.tableView.dequeueReusableCellWithIdentifier("cardholderNameCell") as! MPCardholderNameTableViewCell
		self.cardholderNameCell.height = 55.0
		self.cardholderNameCell.keyboardDelegate = self
		self.cardholderNameCell.cardholderNameTextField.setEnablePrevious(true, isNextEnabled: true)
		
		var userIdNib = UINib(nibName: "MPUserIdTableViewCell", bundle: MercadoPago.getBundle())
		self.tableView.registerNib(userIdNib, forCellReuseIdentifier: "userIdCell")
		self.userIdCell = self.tableView.dequeueReusableCellWithIdentifier("userIdCell") as! MPUserIdTableViewCell
		self.userIdCell._setIdentificationTypes(self.identificationTypes)
		self.userIdCell.height = 55.0
		self.userIdCell.keyboardDelegate = self
		self.userIdCell.userIdValueTextField.setEnablePrevious(true, isNextEnabled: true)
		
		var securityCodeNib = UINib(nibName: "SimpleSecurityCodeTableViewCell", bundle: nil)
		self.tableView.registerNib(securityCodeNib, forCellReuseIdentifier: "securityCodeCell")
		self.securityCodeCell = self.tableView.dequeueReusableCellWithIdentifier("securityCodeCell") as! SimpleSecurityCodeTableViewCell
		self.securityCodeCell.height = 55.0
		self.securityCodeCell.keyboardDelegate = self
		self.securityCodeCell.securityCodeTextField.setEnablePrevious(true, isNextEnabled: false)
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.autoresizesSubviews = true
		self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			return self.cardNumberCell
		} else if indexPath.row == 1 {
			return self.expirationDateCell
		}  else if indexPath.row == 2 {
			return self.cardholderNameCell
		}  else if indexPath.row == 3 {
			return self.userIdCell
		}  else if indexPath.row == 4 {
			return self.securityCodeCell
		}
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return self.cardNumberCell.getHeight()
		} else if indexPath.row == 1 {
			return self.expirationDateCell.getHeight()
		}  else if indexPath.row == 2 {
			return self.cardholderNameCell.getHeight()
		}  else if indexPath.row == 3 {
			return self.userIdCell.getHeight()
		}  else if indexPath.row == 4 {
			return self.securityCodeCell.getHeight()
		}
		return 55
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
