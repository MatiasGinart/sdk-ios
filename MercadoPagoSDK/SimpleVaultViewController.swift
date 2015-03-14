//
//  SimpleVaultViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 3/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class SimpleVaultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var publicKey: String?
    var baseUrl: String?
    var getCustomerUri: String?
    var merchantAccessToken: String?
    var callback: ((paymentMethod: PaymentMethod, token: Token?) -> Void)?
    var supportedPaymentTypes: [String]?
    
    @IBOutlet weak var tableview : UITableView!
    
    @IBOutlet weak var paymentMethodCell : MPPaymentMethodTableViewCell!
    @IBOutlet weak var securityCodeCell : MPSecurityCodeTableViewCell!
    @IBOutlet weak var emptyPaymentMethodCell : MPPaymentMethodEmptyTableViewCell!

    var loadingView : UILoadingView!
    
    // User's saved card
    var selectedCard : Card? = nil
    // New card
    var newCard : Bool = false
    var selectedCardToken : CardToken? = nil
    // New card paymentMethod
    var selectedPaymentMethod : PaymentMethod? = nil
    
    var cards : [Card]?
    
    var securityCodeRequired : Bool = true
    var securityCodeLength : Int = 0
    var bin : String?
    
    init(merchantPublicKey: String, merchantBaseUrl: String, merchantGetCustomerUri: String, merchantAccessToken: String, supportedPaymentTypes: [String], callback: ((paymentMethod: PaymentMethod, token: Token?) -> Void)?) {
        super.init(nibName: "SimpleVaultViewController", bundle: nil)
        self.publicKey = merchantPublicKey
        self.baseUrl = merchantBaseUrl
        self.getCustomerUri = merchantGetCustomerUri
        self.merchantAccessToken = merchantAccessToken
        self.supportedPaymentTypes = supportedPaymentTypes
        self.callback = callback
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        declareAndInitCells()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Realiza tu pago"
        
        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...")
        self.view.addSubview(self.loadingView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirmar", style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        declareAndInitCells()
        
        MerchantServer.getCustomer(self.baseUrl!, merchantGetCustomerUri: self.getCustomerUri!, merchantAccessToken: self.merchantAccessToken!, success: { (customer: Customer) -> Void in
                self.cards = customer.cards
                self.loadingView.removeFromSuperview()
                self.tableview.reloadData()
            }, failure: nil)
    }
    
    func declareAndInitCells() {
        var paymentMethodNib = UINib(nibName: "MPPaymentMethodTableViewCell", bundle: nil)
        self.tableview.registerNib(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
        self.paymentMethodCell = self.tableview.dequeueReusableCellWithIdentifier("paymentMethodCell") as MPPaymentMethodTableViewCell
        
        var emptyPaymentMethodNib = UINib(nibName: "MPPaymentMethodEmptyTableViewCell", bundle: nil)
        self.tableview.registerNib(emptyPaymentMethodNib, forCellReuseIdentifier: "emptyPaymentMethodCell")
        self.emptyPaymentMethodCell = self.tableview.dequeueReusableCellWithIdentifier("emptyPaymentMethodCell") as MPPaymentMethodEmptyTableViewCell

        var securityCodeNib = UINib(nibName: "MPSecurityCodeTableViewCell", bundle: nil)
        self.tableview.registerNib(securityCodeNib, forCellReuseIdentifier: "securityCodeCell")
        self.securityCodeCell = self.tableview.dequeueReusableCellWithIdentifier("securityCodeCell") as MPSecurityCodeTableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.selectedCard == nil && !newCard) {
            return 1
        } else if !self.securityCodeRequired {
            self.navigationItem.rightBarButtonItem?.enabled = true
            return 1
        }
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if (!newCard && self.selectedCard == nil) {
                return self.emptyPaymentMethodCell
            } else {
                if newCard {
                    self.paymentMethodCell.fillWithCardTokenAndPaymentMethod(self.selectedCardToken, paymentMethod: self.selectedPaymentMethod!)
                } else {
                    self.paymentMethodCell.fillWithCard(self.selectedCard)
                }
                return self.paymentMethodCell
            }
        } else if indexPath.row == 1 {
            self.securityCodeCell.fillWithPaymentMethod(self.selectedPaymentMethod!)
            self.securityCodeCell.securityCodeTextField.delegate = self
            return self.securityCodeCell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1) {
            return 115
        }
        return 65
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            let paymentMethodsViewController = MercadoPago.startPaymentMethodsViewController(self.publicKey!, supportedPaymentTypes: self.supportedPaymentTypes!, callback: getSelectionCallbackPaymentMethod())
            
            if self.cards != nil {
                if self.cards!.count > 0 {
                    let customerPaymentMethodsViewController = CustomerCardsViewController(cards: self.cards, callback: getCustomerPaymentMethodCallback(paymentMethodsViewController))
                    showViewController(customerPaymentMethodsViewController, sender: self)
                } else {
                    showViewController(paymentMethodsViewController, sender: self)
                }
            }
        }
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        var txtAfterUpdate:NSString = self.securityCodeCell.securityCodeTextField.text as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        
        if txtAfterUpdate.length < self.securityCodeLength {
            self.navigationItem.rightBarButtonItem?.enabled = false
            return true
        } else if txtAfterUpdate.length == self.securityCodeLength {
            self.navigationItem.rightBarButtonItem?.enabled = true
            return true
        }
        return false
    }
    
    func getCustomerPaymentMethodCallback(paymentMethodsViewController : PaymentMethodsViewController) -> (selectedCard: Card?) -> Void {
        return {(selectedCard: Card?) -> Void in
            if selectedCard != nil {
                self.selectedCard = selectedCard
                self.selectedPaymentMethod = self.selectedCard!.paymentMethod
                self.securityCodeRequired = self.selectedCard!.securityCode!.length! != 0
                self.newCard = false
                self.securityCodeLength = self.selectedCard!.securityCode!.length!
                self.bin = self.selectedCard!.firstSixDigits
                self.tableview.reloadData()
                self.navigationController!.popViewControllerAnimated(true)
            } else {
                self.showViewController(paymentMethodsViewController, sender: self)
            }
        }
    }
    
    func getSelectionCallbackPaymentMethod() -> (paymentMethod : PaymentMethod) -> Void {
        return { (paymentMethod : PaymentMethod) -> Void in
            self.selectedCard = nil
            self.newCard = true
            self.selectedPaymentMethod = paymentMethod
            if paymentMethod.settings != nil && paymentMethod.settings.count > 0 {
                self.securityCodeLength = paymentMethod.settings![0].securityCode!.length!
                self.securityCodeRequired = self.securityCodeLength != 0
            }
            self.showViewController(MercadoPago.startNewCardViewController(MercadoPago.PUBLIC_KEY, key: self.publicKey!, paymentMethod: self.selectedPaymentMethod!, requireSecurityCode: self.securityCodeRequired, callback: self.getNewCardCallback()), sender: self)
        }
    }
    
    func getNewCardCallback() -> (cardToken: CardToken) -> Void {
        return { (cardToken: CardToken) -> Void in
            self.selectedCardToken = cardToken
            self.bin = self.selectedCardToken!.getBin()
            if self.selectedPaymentMethod!.settings != nil && self.selectedPaymentMethod!.settings.count > 0 {
                self.securityCodeRequired = self.selectedPaymentMethod!.settings[0].securityCode!.length! != 0
                self.securityCodeLength = self.selectedPaymentMethod!.settings[0].securityCode!.length!
            }
            self.tableview.reloadData()
            self.navigationController!.popToViewController(self, animated: true)
        }
    }
    
    func getCreatePaymentCallback() -> (token: Token?) -> Void {
        return { (token: Token?) -> Void in
            self.callback!(paymentMethod: self.selectedPaymentMethod!, token: token)
        }
    }
    
    func submitForm() {

        let mercadoPago : MercadoPago = MercadoPago(publicKey: self.publicKey!)
        
        // Create token
        if selectedCard != nil {
            let securityCode = self.securityCodeRequired ? securityCodeCell.securityCodeTextField.text : nil
            
            let savedCardToken : SavedCardToken = SavedCardToken(cardId: String(format:"%ld",selectedCard!.id!), securityCode: securityCode, securityCodeRequired: self.securityCodeRequired)
            
            if savedCardToken.validate() {
                // Send card id to get token id
                self.view.addSubview(self.loadingView)
                mercadoPago.createToken(savedCardToken, success: getCreatePaymentCallback(), failure: nil)
            } else {
                println("Invalid data")
                return
            }
        } else {
            self.selectedCardToken!.securityCode = self.securityCodeCell.securityCodeTextField.text
            if true {
                //TODO: self.selectedCardToken!.validateCard() {
                // Send card data to get token id
                self.view.addSubview(self.loadingView)
                mercadoPago.createNewCardToken(self.selectedCardToken!, success: getCreatePaymentCallback(), failure: nil)
            } else {
                println("Invalid data")
            }
        }
    }

}
