//
//  VaultViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class VaultViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    // ViewController parameters
    var publicKey: String?
    var baseUrl: String?
    var getCustomerUri: String?
    var merchantAccessToken: String?
    var amount : Double?
    
    var callback : ((paymentMethod: PaymentMethod, token: Token?, cardIssuerId: Int?, installments: Int?) -> Void)?
    
    // Input controls
    @IBOutlet weak private var tableview : UITableView!
    @IBOutlet weak private var emptyPaymentMethodCell : MPPaymentMethodEmptyTableViewCell!
    @IBOutlet weak private var paymentMethodCell : MPPaymentMethodTableViewCell!
    @IBOutlet weak private var installmentsCell : MPInstallmentsTableViewCell!
    @IBOutlet weak private var securityCodeCell : MPSecurityCodeTableViewCell!
    var loadingView : UILoadingView!
    
    // Current values
    var selectedCard : Card? = nil
    var selectedPayerCost : PayerCost? = nil
    var selectedCardToken : CardToken? = nil
    var selectedPaymentMethod : PaymentMethod? = nil
    var selectedIssuer : Issuer? = nil
    var newCard : Bool = false
    var cards : [Card]?
    var payerCosts : [PayerCost]?

    var securityCodeRequired : Bool = true
    var securityCodeLength : Int = 0
    var bin : String?
    
    var supportedPaymentTypes : [String]?
    
    init(merchantPublicKey: String, merchantBaseUrl: String, merchantGetCustomerUri: String?, merchantAccessToken: String, amount: Double, supportedPaymentTypes: [String], callback: (paymentMethod: PaymentMethod, token: Token?, cardIssuerId: Int?, installments: Int?) -> Void) {
        super.init(nibName: "VaultViewController", bundle: nil)
        self.baseUrl = merchantBaseUrl
        self.getCustomerUri = merchantGetCustomerUri
        self.merchantAccessToken = merchantAccessToken
        self.publicKey = merchantPublicKey
        self.amount = amount
        self.callback = callback
        self.supportedPaymentTypes = supportedPaymentTypes
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(nibName: "VaultViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        
        var installmentsNib = UINib(nibName: "MPInstallmentsTableViewCell", bundle: nil)
        self.tableview.registerNib(installmentsNib, forCellReuseIdentifier: "installmentsCell")
        self.installmentsCell = self.tableview.dequeueReusableCellWithIdentifier("installmentsCell") as MPInstallmentsTableViewCell
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.selectedCard == nil && !newCard) && (self.selectedPaymentMethod == nil || !MercadoPago.isCardPaymentType(self.selectedPaymentMethod!.paymentTypeId)) {
            return 1
        }
        else if self.selectedPayerCost == nil {
            return 2
        } else if !securityCodeRequired {
            return 2
        }
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if !newCard && self.selectedCard == nil && self.selectedPaymentMethod == nil {
                self.emptyPaymentMethodCell = self.tableview.dequeueReusableCellWithIdentifier("emptyPaymentMethodCell") as MPPaymentMethodEmptyTableViewCell
                return self.emptyPaymentMethodCell
            } else {
                self.paymentMethodCell = self.tableview.dequeueReusableCellWithIdentifier("paymentMethodCell") as MPPaymentMethodTableViewCell
                if !MercadoPago.isCardPaymentType(self.selectedPaymentMethod!.paymentTypeId) {
                    self.paymentMethodCell.fillWithPaymentMethod(self.selectedPaymentMethod!)
                }
                else if newCard {
                    self.paymentMethodCell.fillWithCardTokenAndPaymentMethod(self.selectedCardToken, paymentMethod: self.selectedPaymentMethod!)
                } else {
                    self.paymentMethodCell.fillWithCard(self.selectedCard)
                }
                return self.paymentMethodCell
            }
        } else if indexPath.row == 1 {
            self.installmentsCell = self.tableview.dequeueReusableCellWithIdentifier("installmentsCell") as MPInstallmentsTableViewCell
            self.installmentsCell.fillWithPayerCost(self.selectedPayerCost, amount: self.amount!)
            return self.installmentsCell
        } else if indexPath.row == 2 {
            self.securityCodeCell = self.tableview.dequeueReusableCellWithIdentifier("securityCodeCell") as MPSecurityCodeTableViewCell
            self.securityCodeCell.fillWithPaymentMethod(self.selectedPaymentMethod!)
            self.securityCodeCell.securityCodeTextField.delegate = self
            return self.securityCodeCell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 2) {
            return 115
        }
        return 65
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let paymentMethodsViewController = MercadoPago.startPaymentMethodsViewController(self.publicKey!, supportedPaymentTypes: self.supportedPaymentTypes!, callback: { (paymentMethod : PaymentMethod) -> Void in
                self.selectedPaymentMethod = paymentMethod
                if MercadoPago.isCardPaymentType(paymentMethod.paymentTypeId) {
                    self.selectedCard = nil
                    self.newCard = true
                    if paymentMethod.settings != nil && paymentMethod.settings.count > 0 {
                        self.securityCodeLength = paymentMethod.settings![0].securityCode!.length!
                        self.securityCodeRequired = self.securityCodeLength != 0
                    }

                    let newCardViewController = MercadoPago.startNewCardViewController(MercadoPago.PUBLIC_KEY, key: ExamplesUtils.MERCHANT_PUBLIC_KEY, paymentMethod: self.selectedPaymentMethod!, requireSecurityCode: self.securityCodeRequired, callback: { (cardToken: CardToken) -> Void in
                        self.selectedCardToken = cardToken
                        self.bin = self.selectedCardToken?.getBin()
                        self.loadPayerCosts()
                        self.navigationController!.popToViewController(self, animated: true)
                    })
                    
                    if self.selectedPaymentMethod!.isIssuerRequired() {
                        let issuerViewController = MercadoPago.startIssuersViewController(ExamplesUtils.MERCHANT_PUBLIC_KEY, paymentMethod: self.selectedPaymentMethod!,
                            callback: { (issuer: Issuer) -> Void in
                                self.selectedIssuer = issuer
                                self.tableview.reloadData()
                                self.showViewController(newCardViewController, sender: self)
                        })
                        self.showViewController(issuerViewController, sender: self)
                    } else {
                        self.showViewController(newCardViewController, sender: self)
                    }
                } else {
                    self.tableview.reloadData()
                    self.navigationController!.popToViewController(self, animated: true)
                }
            })

            if self.cards != nil {
                if self.cards!.count > 0 {
                    let customerPaymentMethodsViewController = MercadoPago.startCustomerCardsViewController(self.cards!, callback: {(selectedCard: Card?) -> Void in
                        if selectedCard != nil {
                            self.selectedCard = selectedCard
                            self.selectedPaymentMethod = self.selectedCard?.paymentMethod
                            self.selectedIssuer = self.selectedCard?.issuer
                            self.newCard = false
                            self.bin = self.selectedCard?.firstSixDigits
                            self.securityCodeLength = self.selectedCard!.securityCode!.length
                            self.securityCodeRequired = self.securityCodeLength > 0
                            self.loadPayerCosts()
                            self.navigationController!.popViewControllerAnimated(true)
                        } else {
                            self.showViewController(paymentMethodsViewController, sender: self)
                        }
                    })
                    showViewController(customerPaymentMethodsViewController, sender: self)
                } else {
                    showViewController(paymentMethodsViewController, sender: self)
                }
            }
        } else if indexPath.row == 1 {
            self.showViewController(MercadoPago.startInstallmentsViewController(payerCosts!, amount: amount!, callback: { (payerCost: PayerCost?) -> Void in
                    self.selectedPayerCost = payerCost
                    self.tableview.reloadData()
                    self.navigationController!.popToViewController(self, animated: true)
                }), sender: self)
        }
    }
    
    func loadPayerCosts() {
        self.view.addSubview(self.loadingView)
        let mercadoPago : MercadoPago = MercadoPago(publicKey: self.publicKey!)
        mercadoPago.getInstallments(self.bin!, amount: self.amount!, issuerId: self.selectedIssuer?.id, paymentTypeId: self.selectedPaymentMethod!.paymentTypeId!, success: {(installments: [Installment]?) -> Void in
            if installments != nil {
                self.payerCosts = installments![0].payerCosts
                self.tableview.reloadData()
                self.loadingView.removeFromSuperview()
            }
            }, failure: nil)
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
                mercadoPago.createToken(savedCardToken, success: {(token: Token?) -> Void in
                    self.callback!(paymentMethod: self.selectedPaymentMethod!, token: token, cardIssuerId: self.selectedIssuer?.id, installments: self.selectedPayerCost?.installments)
                }, failure: nil)
            } else {
                println("Invalid data")
                return
            }
        } else {
            self.selectedCardToken!.securityCode = self.securityCodeCell.securityCodeTextField.text
            self.view.addSubview(self.loadingView)
            mercadoPago.createNewCardToken(self.selectedCardToken!, success: {(token: Token?) -> Void in
                self.callback!(paymentMethod: self.selectedPaymentMethod!, token: token, cardIssuerId: self.selectedIssuer?.id, installments: self.selectedPayerCost?.installments)
                }, failure: nil)
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
    
}