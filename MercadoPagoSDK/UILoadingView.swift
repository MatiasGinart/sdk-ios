//
//  UILoadingView.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import UIKit

class UILoadingView : UIView {
    
    init(frame rect: CGRect, text: NSString = "Cargando...") {
        super.init(frame: rect)
        self.backgroundColor = UIColor.whiteColor()
        self.label.text = text
        self.label.textColor = self.spinner.color
        self.spinner.startAnimating()
        
        self.addSubview(self.label)
        self.addSubview(self.spinner)
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        self.setNeedsLayout()
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var label : UILabel = {
        var l = UILabel()
        l.font = UIFont(name: "HelveticaNeue", size: 15)
        return l
        }()
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func layoutSubviews() {
        self.label.sizeToFit()
        var labelSize: CGSize = self.label.frame.size
        var labelFrame: CGRect = CGRect()
        labelFrame.size = labelSize
        self.label.frame = labelFrame
        
        // center label and spinner
        self.label.center = self.center
        self.spinner.center = self.center
        
        // horizontally align
        labelFrame = self.label.frame
        var spinnerFrame: CGRect = self.spinner.frame
        var totalWidth: CGFloat = spinnerFrame.size.width + 5 + labelSize.width
        spinnerFrame.origin.x = self.bounds.origin.x + (self.bounds.size.width - totalWidth) / 2
        labelFrame.origin.x = spinnerFrame.origin.x + spinnerFrame.size.width + 5
        self.label.frame = labelFrame
        self.spinner.frame = spinnerFrame
    }
    
}
