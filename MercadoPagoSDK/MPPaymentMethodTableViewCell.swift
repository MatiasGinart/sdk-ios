//
//  MPPaymentMethodTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class MPPaymentMethodTableViewCell : UITableViewCell {
    @IBOutlet weak private var cardTextLabel : UITextField!
    @IBOutlet weak private var cardIcon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillWithCard(card : Card?) {
        if card == nil || card!.paymentMethod == nil {
            self.cardTextLabel.text = "Selecciona un medio de pago..."
            self.cardIcon.image = UIImage(named: "empty_tc")
        } else {
            self.cardTextLabel.text = card!.paymentMethod!.name + " terminada en " + card!.lastFourDigits!
            self.cardIcon.image = UIImage(named:"icoTc_" + card!.paymentMethod!.id)
        }
    }
    
    func fillWithCardTokenAndPaymentMethod(card : CardToken?, paymentMethod : PaymentMethod?) {
        if card == nil || paymentMethod == nil {
            self.cardTextLabel.text = "Selecciona un medio de pago..."
            self.cardIcon.image = UIImage(named: "empty_tc")
        } else {
            let range = Range(start: advance(card!.cardNumber!.endIndex, -4),
                end: card!.cardNumber!.endIndex)
            let lastFourDigits : String = card!.cardNumber!.substringWithRange(range)
            self.cardTextLabel.text = paymentMethod!.name + " terminada en " + lastFourDigits
            self.cardIcon.image = UIImage(named:"icoTc_" + paymentMethod!.id)
        }
    }
    
    func fillWithPaymentMethod(paymentMethod : PaymentMethod?) {
        if paymentMethod == nil {
            self.cardTextLabel.text = "Selecciona un medio de pago..."
            self.cardIcon.image = UIImage(named: "empty_tc")
        } else {
           self.cardTextLabel.text = paymentMethod!.name
            self.cardIcon.image = UIImage(named:"icoTc_" + paymentMethod!.id)
        }
    }
    
}
