//
//  MPPaymentMethodTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPPaymentMethodTableViewCell : UITableViewCell {
    @IBOutlet weak private var cardTextLabel : UITextField!
    @IBOutlet weak private var cardIcon : UIImageView!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func fillWithCard(card : Card?) {
        if card == nil || card!.paymentMethod == nil {
            self.cardTextLabel.text = "Selecciona un medio de pago..."
            self.cardIcon.image = UIImage(named: "empty_tc", inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
        } else {
            self.cardTextLabel.text = card!.paymentMethod!.name + " terminada en " + card!.lastFourDigits!
            self.cardIcon.image = UIImage(named: "icoTc_" + card!.paymentMethod!.id, inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
        }
    }
    
    public func fillWithCardTokenAndPaymentMethod(card : CardToken?, paymentMethod : PaymentMethod?) {
        if card == nil || paymentMethod == nil {
            self.cardTextLabel.text = "Selecciona un medio de pago..."
            self.cardIcon.image = UIImage(named: "empty_tc", inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
        } else {
            let range = Range(start: advance(card!.cardNumber!.endIndex, -4),
                end: card!.cardNumber!.endIndex)
            let lastFourDigits : String = card!.cardNumber!.substringWithRange(range)
            self.cardTextLabel.text = paymentMethod!.name + " terminada en " + lastFourDigits
            self.cardIcon.image = UIImage(named: "icoTc_" + paymentMethod!.id, inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
        }
    }
    
    public func fillWithPaymentMethod(paymentMethod : PaymentMethod?) {
        if paymentMethod == nil {
            self.cardTextLabel.text = "Selecciona un medio de pago..."
            self.cardIcon.image = UIImage(named: "empty_tc", inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
        } else {
           self.cardTextLabel.text = paymentMethod!.name
            self.cardIcon.image = UIImage(named: "icoTc_" + paymentMethod!.id, inBundle: MercadoPago.getBundle(), compatibleWithTraitCollection:nil)
        }
    }
    
}
