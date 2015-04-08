//
//  IssuerTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 9/1/15.
//  Copyright (c) 2015 com.mercadopago. All rights reserved.
//

import UIKit

public class IssuerTableViewCell: UITableViewCell {
    @IBOutlet private weak var issuerLabel : UILabel!
    
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
 
    public func fillWithIssuer(issuer : Issuer) {
        issuerLabel.text = issuer.name == "default" ? "Otro banco" : issuer.name
    }
    
}
