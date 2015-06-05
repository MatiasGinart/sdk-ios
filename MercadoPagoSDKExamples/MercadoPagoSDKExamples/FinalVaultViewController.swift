//
//  FinalVaultViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 4/2/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import MercadoPagoSDK

class FinalVaultViewController : AdvancedVaultViewController {

    var finalCallback : ((paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int) -> Void)?
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(merchantPublicKey: String, merchantBaseUrl: String, merchantGetCustomerUri: String, merchantAccessToken: String, amount: Double, supportedPaymentTypes: [String], callback: (paymentMethod: PaymentMethod, token: String?, issuerId: Int64?, installments: Int) -> Void) {
        super.init(merchantPublicKey: merchantPublicKey, merchantBaseUrl: merchantBaseUrl, merchantGetCustomerUri: merchantGetCustomerUri, merchantAccessToken: merchantAccessToken, amount: amount, supportedPaymentTypes: supportedPaymentTypes, callback: nil)
        self.finalCallback = callback
    }
   
    override func getSelectionCallbackPaymentMethod() -> (paymentMethod : PaymentMethod) -> Void {
        return { (paymentMethod : PaymentMethod) -> Void in
            self.selectedPaymentMethod = paymentMethod
            if MercadoPago.isCardPaymentType(paymentMethod.paymentTypeId) {
                self.selectedCard = nil
                self.newCard = true
                if paymentMethod.settings != nil && paymentMethod.settings.count > 0 {
                    self.securityCodeLength = paymentMethod.settings![0].securityCode!.length
                    self.securityCodeRequired = self.securityCodeLength != 0
                }
                let newCardViewController = MercadoPago.startNewCardViewController(MercadoPago.PUBLIC_KEY, key: ExamplesUtils.MERCHANT_PUBLIC_KEY, paymentMethod: self.selectedPaymentMethod!, requireSecurityCode: self.securityCodeRequired, callback: self.getNewCardCallback())
                
                if self.selectedPaymentMethod!.isIssuerRequired() {
                    let issuerViewController = MercadoPago.startIssuersViewController(ExamplesUtils.MERCHANT_PUBLIC_KEY, paymentMethod: self.selectedPaymentMethod!,
                        callback: { (issuer: Issuer) -> Void in
                            self.selectedIssuer = issuer
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
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.selectedCard == nil && !newCard) && (self.selectedCardToken == nil) || (self.selectedPaymentMethod != nil && !MercadoPago.isCardPaymentType(self.selectedPaymentMethod!.paymentTypeId)) {
            return 1
        }
        else if self.selectedPayerCost == nil {
            return 2
        } else if !securityCodeRequired {
            return 2
        }
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if !newCard && self.selectedCard == nil && self.selectedPaymentMethod == nil {
                self.emptyPaymentMethodCell = self.tableview.dequeueReusableCellWithIdentifier("emptyPaymentMethodCell") as! MPPaymentMethodEmptyTableViewCell
                return self.emptyPaymentMethodCell
            } else {
                self.paymentMethodCell = self.tableview.dequeueReusableCellWithIdentifier("paymentMethodCell") as! MPPaymentMethodTableViewCell
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
            self.installmentsCell = self.tableview.dequeueReusableCellWithIdentifier("installmentsCell") as! MPInstallmentsTableViewCell
            self.installmentsCell.fillWithPayerCost(self.selectedPayerCost, amount: self.amount)
            return self.installmentsCell
        } else if indexPath.row == 2 {
            self.securityCodeCell = self.tableview.dequeueReusableCellWithIdentifier("securityCodeCell") as! MPSecurityCodeTableViewCell
            self.securityCodeCell.fillWithPaymentMethod(self.selectedPaymentMethod!)
            self.securityCodeCell.securityCodeTextField.delegate = self
            return self.securityCodeCell
        }
        return UITableViewCell()
    }

}