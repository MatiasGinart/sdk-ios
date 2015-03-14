//
//  CardViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var publicKey : String?
    
    @IBOutlet weak var tableView : UITableView!
    var cardNumberCell : MPCardNumberTableViewCell!
    var expirationDateCell : MPExpirationDateTableViewCell!
    var cardholderNameCell : MPCardholderNameTableViewCell!
    var userIdCell : MPUserIdTableViewCell!
    var securityCodeCell : SimpleSecurityCodeTableViewCell!
    
    var paymentMethod : PaymentMethod!
    
    var errorCell : MPErrorTableViewCell!
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
    
    override init() {
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
        
        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...")
        self.view.addSubview(self.loadingView)
        self.title = "Datos de la tarjeta"
        
        self.navigationItem.backBarButtonItem?.title = "Atrás"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
        
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
        
        let cardToken = CardToken(cardNumber: self.cardNumberCell.getCardNumber(), expirationMonth: self.expirationDateCell.getExpirationMonth(), expirationYear: self.expirationDateCell.getExpirationYear(), securityCode: self.securityCodeCell.getSecurityCode(), cardholderName: self.cardholderNameCell.getCardholderName(), docType: self.userIdCell.getUserIdType(), docNumber: self.userIdCell.getUserIdValue())
        
      //  self.view.addSubview(self.loadingView)
        
        if validateForm(cardToken) {
            createToken(cardToken)
        } else {
            self.hasError = true
            self.tableView.reloadData()
         //   self.loadingView.removeFromSuperview()
        }
    }
    
    func prepareTableView() {
        
        var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: nil)
        self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
        self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as MPCardNumberTableViewCell
        self.cardNumberCell.setIcon(self.paymentMethod.id)
        self.cardNumberCell.setSetting(self.paymentMethod.settings[0])

        var expirationDateNib = UINib(nibName: "MPExpirationDateTableViewCell", bundle: nil)
        self.tableView.registerNib(expirationDateNib, forCellReuseIdentifier: "expirationDateCell")
        self.expirationDateCell = self.tableView.dequeueReusableCellWithIdentifier("expirationDateCell") as MPExpirationDateTableViewCell
        
        var cardholderNameNib = UINib(nibName: "MPCardholderNameTableViewCell", bundle: nil)
        self.tableView.registerNib(cardholderNameNib, forCellReuseIdentifier: "cardholderNameCell")
        self.cardholderNameCell = self.tableView.dequeueReusableCellWithIdentifier("cardholderNameCell") as MPCardholderNameTableViewCell
        
        var userIdNib = UINib(nibName: "MPUserIdTableViewCell", bundle: nil)
        self.tableView.registerNib(userIdNib, forCellReuseIdentifier: "userIdCell")
        self.userIdCell = self.tableView.dequeueReusableCellWithIdentifier("userIdCell") as MPUserIdTableViewCell
        self.userIdCell.setIdentificationTypes(self.identificationTypes)
        
        var securityCodeNib = UINib(nibName: "SimpleSecurityCodeTableViewCell", bundle: nil)
        self.tableView.registerNib(securityCodeNib, forCellReuseIdentifier: "securityCodeCell")
        self.securityCodeCell = self.tableView.dequeueReusableCellWithIdentifier("securityCodeCell") as SimpleSecurityCodeTableViewCell
        
        var errorNib = UINib(nibName: "MPErrorTableViewCell", bundle: nil)
        self.tableView.registerNib(errorNib, forCellReuseIdentifier: "errorCell")
        self.errorCell = self.tableView.dequeueReusableCellWithIdentifier("errorCell") as MPErrorTableViewCell
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hasError ? 6 : 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var index : Int = indexPath.row
        
        if self.hasError && index == 0 {
            return self.errorCell
        }
        
        if self.hasError {
            index = indexPath.row - 1
        }
        
        if index == 0 {
            return self.cardNumberCell
        } else if index == 1 {
            return self.securityCodeCell
        } else if index == 2 {
            return self.expirationDateCell
        }  else if index == 3 {
            return self.cardholderNameCell
        }  else if index == 4 {
            return self.userIdCell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func validateForm(cardToken : CardToken) -> Bool {
        
        var result = true
        var focusSet = false
        
        // Validate card number
        if validateCardNumber(cardToken) {
            // TODO: setError null
        } else {
            // TODO: setError Message
            // Focus en card number
            result = false
            focusSet = true
        }
        
        // Validate security code
        if validateSecurityCode(cardToken) {
            // TODO: setError null
        } else {
            // TODO: setError Message
            if !focusSet {
                // Focus en securityCode
                focusSet = true
            }
            result = false
        }
        
        // Validate expiry date
        if !cardToken.validateExpiryDate() {
            // TODO: set error "Revisa este dato" en expiryDate
            result = false
        } else {
            // TODO: set error null
        }
        
        // Validate card holder name
        if !cardToken.validateCardholderName() {
            // TODO: set error "Revisa este dato" en cardholder name
            if !focusSet {
                // Focus en cardholder
                focusSet = true
            }
            result = false
        } else {
            // TODO: setError null
        }
        
        // Validate identification number
        if identificationType != nil {
            if !cardToken.validateIdentificationNumber(identificationType) {
                // TODO: setError "Revisa este dato" en identificationNumber
                if !focusSet {
                    // TODO: Focus en identificationNumber
                }
                result = false
            } else {
                // TODO: setError null
            }
        }
        
        return result
    }
    
    func validateCardNumber(cardToken: CardToken) -> Bool {
        return cardToken.validateCardNumber()
    }
    
    func validateSecurityCode(cardToken: CardToken) -> Bool {
        return cardToken.validateSecurityCode()
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        let cell = textField.superview?.superview as UITableViewCell?
        self.tableView.scrollToRowAtIndexPath(self.tableView.indexPathForCell(cell!)!, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func createToken(cardToken: CardToken) {
        let mercadoPago = MercadoPago(publicKey: self.publicKey!)
        mercadoPago.createNewCardToken(cardToken, success: callback!, failure: nil)
    }
}
