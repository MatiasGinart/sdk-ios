//
//  NewCardViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class NewCardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        
        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...".localized)
        
        self.title = "Datos de tu tarjeta".localized
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Atrás".localized, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continuar".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
        
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
    
    public func prepareTableView() {
        var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
        self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as! MPCardNumberTableViewCell
        self.cardNumberCell.height = 55
        self.cardNumberCell.setIcon(self.paymentMethod!.id)
        self.cardNumberCell._setSetting(self.paymentMethod!.settings?[0])

        var expirationDateNib = UINib(nibName: "MPExpirationDateTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(expirationDateNib, forCellReuseIdentifier: "expirationDateCell")
        self.expirationDateCell = self.tableView.dequeueReusableCellWithIdentifier("expirationDateCell") as! MPExpirationDateTableViewCell
        self.expirationDateCell.height = 55
        
        var cardholderNameNib = UINib(nibName: "MPCardholderNameTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(cardholderNameNib, forCellReuseIdentifier: "cardholderNameCell")
        self.cardholderNameCell = self.tableView.dequeueReusableCellWithIdentifier("cardholderNameCell") as! MPCardholderNameTableViewCell
        self.cardholderNameCell.height = 55

        var userIdNib = UINib(nibName: "MPUserIdTableViewCell", bundle: self.bundle)
        self.tableView.registerNib(userIdNib, forCellReuseIdentifier: "userIdCell")
        self.userIdCell = self.tableView.dequeueReusableCellWithIdentifier("userIdCell") as! MPUserIdTableViewCell
        self.userIdCell._setIdentificationTypes(self.identificationTypes)
        self.userIdCell.height = 55
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.autoresizesSubviews = true
        self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
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
        return 4
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            return self.cardNumberCell
        } else if indexPath.row == 1 {
            return self.expirationDateCell
        }  else if indexPath.row == 2 {
            return self.cardholderNameCell
        }  else if indexPath.row == 3 {
            return self.userIdCell
        }
        return UITableViewCell()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.cardNumberCell.getHeight()
        } else if indexPath.row == 1 {
            return self.expirationDateCell.getHeight()
        }  else if indexPath.row == 2 {
            return self.cardholderNameCell.getHeight()
        }  else if indexPath.row == 3 {
            return self.userIdCell.getHeight()
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