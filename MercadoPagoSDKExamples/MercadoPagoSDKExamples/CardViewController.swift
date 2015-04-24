//
//  CardViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 28/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit
import MercadoPagoSDK

class CardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
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
        
        var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: MercadoPago.getBundle())
        self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
        self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as! MPCardNumberTableViewCell
        self.cardNumberCell.height = 55.0
        self.cardNumberCell.setIcon(self.paymentMethod.id)
        self.cardNumberCell._setSetting(self.paymentMethod.settings[0])

        var expirationDateNib = UINib(nibName: "MPExpirationDateTableViewCell", bundle: MercadoPago.getBundle())
        self.tableView.registerNib(expirationDateNib, forCellReuseIdentifier: "expirationDateCell")
        self.expirationDateCell = self.tableView.dequeueReusableCellWithIdentifier("expirationDateCell") as! MPExpirationDateTableViewCell
        self.expirationDateCell.height = 55.0
        
        var cardholderNameNib = UINib(nibName: "MPCardholderNameTableViewCell", bundle: MercadoPago.getBundle())
        self.tableView.registerNib(cardholderNameNib, forCellReuseIdentifier: "cardholderNameCell")
        self.cardholderNameCell = self.tableView.dequeueReusableCellWithIdentifier("cardholderNameCell") as! MPCardholderNameTableViewCell
        self.cardholderNameCell.height = 55.0
        
        var userIdNib = UINib(nibName: "MPUserIdTableViewCell", bundle: MercadoPago.getBundle())
        self.tableView.registerNib(userIdNib, forCellReuseIdentifier: "userIdCell")
        self.userIdCell = self.tableView.dequeueReusableCellWithIdentifier("userIdCell") as! MPUserIdTableViewCell
        self.userIdCell._setIdentificationTypes(self.identificationTypes)
        self.userIdCell.height = 55.0
        
        var securityCodeNib = UINib(nibName: "SimpleSecurityCodeTableViewCell", bundle: nil)
        self.tableView.registerNib(securityCodeNib, forCellReuseIdentifier: "securityCodeCell")
        self.securityCodeCell = self.tableView.dequeueReusableCellWithIdentifier("securityCodeCell") as! SimpleSecurityCodeTableViewCell
        self.securityCodeCell.height = 55.0
        
        self.tableView.estimatedRowHeight = 55.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        mercadoPago.createNewCardToken(cardToken, success: callback!, failure: nil)
    }
}
