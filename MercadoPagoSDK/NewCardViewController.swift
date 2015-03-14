//
//  NewCardViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 29/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class NewCardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // ViewController parameters
    var key : String?
    var keyType : String?
    var paymentMethod: PaymentMethod?
    var requireSecurityCode : Bool?
    var callback: ((cardToken: CardToken) -> Void)?
    var identificationType : IdentificationType?
    var identificationTypes : [IdentificationType]?
    
    // Input controls
    @IBOutlet weak private var tableView : UITableView!
    var cardNumberCell : MPCardNumberTableViewCell!
    var expirationDateCell : MPExpirationDateTableViewCell!
    var cardholderNameCell : MPCardholderNameTableViewCell!
    var userIdCell : MPUserIdTableViewCell!
    var errorCell : MPErrorTableViewCell!
    var securityCodeCell : MPSecurityCodeTableViewCell!
    var hasError : Bool = false
    var loadingView : UILoadingView!
    
    init(keyType: String, key: String, paymentMethod: PaymentMethod, requireSecurityCode: Bool, callback: ((cardToken: CardToken) -> Void)?) {
        super.init(nibName: "NewCardViewController", bundle: nil)
        self.paymentMethod = paymentMethod
        self.requireSecurityCode = requireSecurityCode
        self.key = key
        self.keyType = keyType
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
        
        self.title = "Datos tarjeta"
        
        self.navigationItem.backBarButtonItem?.title = "Atrás"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "submitForm")
        
        SwiftTryCatch.try({
            () -> Void in
            var mercadoPago : MercadoPago
            mercadoPago = MercadoPago(keyType: self.keyType, key: self.key)
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
            }, catch: {(exception: NSException!) -> Void in }, finally: {() -> Void in })
        
    }
    
    func prepareTableView() {
        var cardNumberNib = UINib(nibName: "MPCardNumberTableViewCell", bundle: nil)
        self.tableView.registerNib(cardNumberNib, forCellReuseIdentifier: "cardNumberCell")
        self.cardNumberCell = self.tableView.dequeueReusableCellWithIdentifier("cardNumberCell") as MPCardNumberTableViewCell
        self.cardNumberCell.setIcon(self.paymentMethod!.id)
        self.cardNumberCell.setSetting(self.paymentMethod!.settings?[0])

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
        
        var errorNib = UINib(nibName: "MPErrorTableViewCell", bundle: nil)
        self.tableView.registerNib(errorNib, forCellReuseIdentifier: "errorCell")
        self.errorCell = self.tableView.dequeueReusableCellWithIdentifier("errorCell") as MPErrorTableViewCell
        
/*        var securityCodeNib = UINib(nibName: "MPSecurityCodeTableViewCell", bundle: nil)
        self.tableView.registerNib(securityCodeNib, forCellReuseIdentifier: "securityCodeCell")
        self.securityCodeCell = self.tableView.dequeueReusableCellWithIdentifier("securityCodeCell") as MPSecurityCodeTableViewCell
        self.securityCodeCell.fillWithPaymentMethod(self.paymentMethod!)
        self.securityCodeCell.securityCodeTextField.delegate = self
        */
        self.tableView.estimatedRowHeight = 55.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func submitForm() {
        
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hasError ? 5 : 4
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
            return self.expirationDateCell
        }  else if index == 2 {
            return self.cardholderNameCell
        }  else if index == 3 {
            return self.userIdCell
        } else if index == 4 {
            return self.securityCodeCell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func validateForm(cardToken : CardToken) -> Bool {
        
        var result : Bool = true
        var focusSet : Bool = false
        
        // Validate expiry date
        if !cardToken.validateCardNumber(paymentMethod!) {
            // TODO : ERROR EN CARD NUMBER
            // TODO : FOCUS EN CARD NUMBER
            self.hasError = true
            focusSet = true
            result = false
        } else {
            // TODO: CLEAR ERROR EN CARD NUMBER
            self.hasError = false
        }
        
        // Validate expiry date
        if !cardToken.validateExpiryDate() {
            // TODO : ERROR EN CARD NUMBER
            // mExpiryDate.setError(getString(com.mercadopago.vault.R.string.error_invalid_expiry_date))
            self.hasError = true
            result = false
        } else {
            // TODO: CLEAR ERROR EN EXP
        }
        
        // Validate card holder name
        if !cardToken.validateCardholderName() {
            // mCardHolderName.setError(getString(com.mercadopago.vault.R.string.invalid_field))
            // TODO: ERROR EN CARDHOLDER
            self.hasError = true
            if !focusSet {
                // TODO: : FOCUS EN CARDHOLDER
                // mCardHolderName.requestFocus()
                focusSet = true
            }
            result = false
        } else {
            // TODO : CLEAR ERROR EN CARDHOLDER mCardHolderName.setError(null);
        }
        
        // Validate identification number
        if false {
            //TODO !cardToken.validateDocType() {
            //TODO : ERROR EN DOC NUMBER mIdentificationNumber.setError(getString(com.mercadopago.vault.R.string.invalid_field))
            if (!focusSet) {
                //TODO : FOCUS EN DOC NUMBER mIdentificationNumber.requestFocus()
            }
            result = false
        } else {
            // TODO: CLEAR ERROR DOC NUMBER mIdentificationNumber.setError(null)
        }
        
        return result
    }
    
}