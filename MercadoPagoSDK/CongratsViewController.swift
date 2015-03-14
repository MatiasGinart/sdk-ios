//
//  CongratsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 11/3/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class CongratsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(nibName: "CongratsViewController", bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(payment: Payment, paymentMethod: PaymentMethod) {
        super.init(nibName: "CongratsViewController", bundle: nil)
        self.payment = payment
        self.paymentMethod = paymentMethod
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        declareAndInitCells()
        
        // Title
        setTitle(payment!)
        
        // Icon
        setIcon(payment!)
        
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
    
    func declareAndInitCells() {
        self.tableView.registerNib(UINib(nibName: "PaymentTotalTableViewCell", bundle: nil), forCellReuseIdentifier: "paymentTotalCell")
        self.paymentTotalCell = self.tableView.dequeueReusableCellWithIdentifier("paymentTotalCell") as PaymentTotalTableViewCell
        
        self.tableView.registerNib(UINib(nibName: "CongratsPaymentMethodTableViewCell", bundle: nil), forCellReuseIdentifier: "congratsPaymentMethodCell")
        self.congratsPaymentMethodCell = self.tableView.dequeueReusableCellWithIdentifier("congratsPaymentMethodCell") as CongratsPaymentMethodTableViewCell
        
        self.tableView.registerNib(UINib(nibName: "PaymentIDTableViewCell", bundle: nil), forCellReuseIdentifier: "paymentIDCell")
        self.paymentIDCell = self.tableView.dequeueReusableCellWithIdentifier("paymentIDCell") as PaymentIDTableViewCell
        
        self.tableView.registerNib(UINib(nibName: "PaymentDateTableViewCell", bundle: nil), forCellReuseIdentifier: "paymentDateCell")
        self.paymentDateCell = self.tableView.dequeueReusableCellWithIdentifier("paymentDateCell") as PaymentDateTableViewCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func setTitle(payment: Payment) {
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
    
    func setIcon(payment: Payment) {
        if payment.status == "approved" {
            self.icon.image = UIImage(named:"ic_approved")
        } else if payment.status == "pending" {
            self.icon.image = UIImage(named:"ic_pending")
        } else if payment.status == "in_process" {
            self.icon.image = UIImage(named:"ic_pending")
        } else if payment.status == "rejected" {
            self.icon.image = UIImage(named:"ic_rejected")
        }
    }
    
    func setDescription(payment: Payment) {
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
    
    func setAmount(payment: Payment) {
        if payment.transactionDetails != nil && payment.transactionDetails.totalPaidAmount != nil && payment.currencyId != nil {
            let formattedAmount : String? = CurrenciesUtil.formatNumber(payment.transactionDetails.totalPaidAmount, currencyId: payment.currencyId)
            if formattedAmount != nil {
                self.paymentTotalCell.lblTotal.text = formattedAmount
            }
        }
    }
    
    func setPaymentId(payment: Payment) {
        self.paymentIDCell!.lblID.text = String(payment.id)
    }
    
    func setPaymentMethodDescription(payment: Payment) {
        if payment.card != nil && payment.card.paymentMethod != nil {
        self.congratsPaymentMethodCell!.lblPaymentInfo.text = " terminada en " + payment.card!.lastFourDigits!
            self.congratsPaymentMethodCell.imgPayment.image = UIImage(named: "icoTc_" + payment.card!.paymentMethod!.id)
        } else if self.paymentMethod != nil {
            self.congratsPaymentMethodCell!.lblPaymentInfo.text = self.paymentMethod!.name
            self.congratsPaymentMethodCell.imgPayment.image = UIImage(named: "icoTc_" + self.paymentMethod.id)
        }
    }
    
    func setDateCreated(payment: Payment) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.paymentDateCell.lblDate.text = dateFormatter.stringFromDate(payment.dateCreated!)
        
    }
    
    func setButtonText(payment: Payment) {
        var title = "Imprimir cupon"
        if payment.status == "pending" {
            // TODO couponUrl = payment.transactionDetails.externalResourceUrl
        } else {
            title = "Terminar"
            // TODO couponUrl = nil
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: "submitForm")
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
}