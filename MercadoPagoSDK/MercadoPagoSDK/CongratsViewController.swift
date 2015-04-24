//
//  CongratsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 11/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class CongratsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var payment: Payment!
    var paymentMethod: PaymentMethod!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDescription: UILabel!
    
    var paymentTotalCell : PaymentTotalTableViewCell!
    var congratsPaymentMethodCell : CongratsPaymentMethodTableViewCell!
    var paymentIDCell : PaymentIDTableViewCell!
    var paymentDateCell : PaymentDateTableViewCell!
    
    var bundle : NSBundle? = MercadoPago.getBundle()
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(payment: Payment, paymentMethod: PaymentMethod) {
        super.init(nibName: "CongratsViewController", bundle: bundle)
        self.payment = payment
        self.paymentMethod = paymentMethod
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        declareAndInitCells()
        
        // Title
        _setTitle(payment!)
        
        // Icon
        _setIcon(payment!)
        
        // Description
        setDescription(payment!)
        
        // Amount
        setAmount(payment!)
        
        // payment id
        setPaymentId(payment!)
        
        // payment method description
        setPaymentMethodDescription(payment!)
        
        // payment creation date
        setDateCreated(payment!)
        
        // Button text
        setButtonText(payment!)
        
        self.tableView.reloadData()
    }
    
    public func declareAndInitCells() {
        self.tableView.registerNib(UINib(nibName: "PaymentTotalTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "paymentTotalCell")
        self.paymentTotalCell = self.tableView.dequeueReusableCellWithIdentifier("paymentTotalCell") as! PaymentTotalTableViewCell
        
        self.tableView.registerNib(UINib(nibName: "CongratsPaymentMethodTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "congratsPaymentMethodCell")
        self.congratsPaymentMethodCell = self.tableView.dequeueReusableCellWithIdentifier("congratsPaymentMethodCell") as! CongratsPaymentMethodTableViewCell
        
        self.tableView.registerNib(UINib(nibName: "PaymentIDTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "paymentIDCell")
        self.paymentIDCell = self.tableView.dequeueReusableCellWithIdentifier("paymentIDCell") as! PaymentIDTableViewCell
        
        self.tableView.registerNib(UINib(nibName: "PaymentDateTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "paymentDateCell")
        self.paymentDateCell = self.tableView.dequeueReusableCellWithIdentifier("paymentDateCell") as! PaymentDateTableViewCell
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.paymentTotalCell
        } else if indexPath.row == 1 {
            return self.congratsPaymentMethodCell
        } else if indexPath.row == 2 {
            return self.paymentIDCell
        } else if indexPath.row == 3 {
            return self.paymentDateCell
        }
        return UITableViewCell()
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func _setTitle(payment: Payment) {
        if payment.status == "approved" {
            self.lblTitle.text = "¡Felicitaciones!"
        } else if payment.status == "pending" {
            self.lblTitle.text = "Hemos procesado tu pago"
        } else if payment.status == "in_process" {
            self.lblTitle.text = "Estamos procesando el pago"
        } else if payment.status == "rejected" {
            self.lblTitle.text = "¡Ups! Ocurrió un problema"
        }
    }
    
    public func _setIcon(payment: Payment) {
        if payment.status == "approved" {
            self.icon.image = UIImage(named:"ic_approved", inBundle: bundle, compatibleWithTraitCollection:nil)
        } else if payment.status == "pending" {
            self.icon.image = UIImage(named:"ic_pending", inBundle: bundle, compatibleWithTraitCollection:nil)
        } else if payment.status == "in_process" {
            self.icon.image = UIImage(named:"ic_pending", inBundle: bundle, compatibleWithTraitCollection:nil)
        } else if payment.status == "rejected" {
            self.icon.image = UIImage(named:"ic_rejected", inBundle: bundle, compatibleWithTraitCollection:nil)
        }
    }
    
    public func setDescription(payment: Payment) {
        if payment.status == "approved" {
            self.lblDescription.text = "Se aprobó tu pago."
        } else if payment.status == "pending" {
            self.lblDescription.text = "Imprime el cupón y paga. Se acreditará en 1 a 3 días hábiles."
        } else if payment.status == "in_process" {
            self.lblDescription.text = "En unos minutos te enviaremos por e-mail el resultado."
        } else if payment.status == "rejected" {
            self.lblDescription.text = "No se pudo realizar el pago."
        }
    }
    
    public func setAmount(payment: Payment) {
        if payment.transactionDetails != nil && payment.transactionDetails.totalPaidAmount != nil && payment.currencyId != nil {
            let formattedAmount : String? = CurrenciesUtil.formatNumber(payment.transactionDetails.totalPaidAmount, currencyId: payment.currencyId)
            if formattedAmount != nil {
                self.paymentTotalCell.lblTotal.text = formattedAmount
            }
        }
    }
    
    public func setPaymentId(payment: Payment) {
        self.paymentIDCell!.lblID.text = String(payment.id)
    }
    
    public func setPaymentMethodDescription(payment: Payment) {
        if payment.card != nil && payment.card.paymentMethod != nil {
        self.congratsPaymentMethodCell!.lblPaymentInfo.text = " terminada en " + payment.card!.lastFourDigits!
            self.congratsPaymentMethodCell.imgPayment.image = UIImage(named: "icoTc_" + payment.card!.paymentMethod!.id, inBundle: bundle, compatibleWithTraitCollection:nil)
        } else if self.paymentMethod != nil {
            self.congratsPaymentMethodCell!.lblPaymentInfo.text = self.paymentMethod!.name
            self.congratsPaymentMethodCell.imgPayment.image = UIImage(named: "icoTc_" + self.paymentMethod.id, inBundle: bundle, compatibleWithTraitCollection:nil)
        }
    }
    
    public func setDateCreated(payment: Payment) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.paymentDateCell.lblDate.text = dateFormatter.stringFromDate(payment.dateCreated!)
        
    }
    
    public func setButtonText(payment: Payment) {
        var title = "Imprimir cupon"
        if payment.status == "pending" {
            // TODO couponUrl = payment.transactionDetails.externalResourceUrl
        } else {
            title = "Terminar"
            // TODO couponUrl = nil
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
    }
    
    public func submitForm() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}