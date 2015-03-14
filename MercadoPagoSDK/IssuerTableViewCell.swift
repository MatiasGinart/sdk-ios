//
//  IssuerTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

class IssuerTableViewCell: UITableViewCell {
    @IBOutlet private weak var issuerLabel : UILabel!
    
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
 
    func fillWithIssuer(issuer : Issuer) {
        issuerLabel.text = issuer.name == "default" ? "Otro banco" : issuer.name
    }
    
}
