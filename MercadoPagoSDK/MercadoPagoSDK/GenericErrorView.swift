//
//  GenericErrorView.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/4/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class GenericErrorView : UIView {
    
    let kErrorOffset : CGFloat = 4
    let kArrowHeight : CGFloat = 8
    let kLabelXOffset : CGFloat = 12
    
    var backgroundImageView : UIImageView!
    var errorLabel : UILabel!
    var minimumHeight : CGFloat!
    var bundle : NSBundle? = MercadoPago.getBundle()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.minimumHeight = 40
        
        self.backgroundImageView = UIImageView(frame: CGRectMake(-1, -1 * kArrowHeight, self.frame.size.width + 1, self.frame.size.height + kArrowHeight))
        self.backgroundImageView.image = UIImage(named: "ErrorBackground.png", inBundle: self.bundle, compatibleWithTraitCollection: nil)?.stretchableImageWithLeftCapWidth(0, topCapHeight: 20)
        self.backgroundImageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleToFill
        self.backgroundImageView.layer.cornerRadius = 0
        self.backgroundImageView.layer.masksToBounds = false
        self.addSubview(self.backgroundImageView)
        
        self.errorLabel = UILabel(frame: CGRectMake(kLabelXOffset, 0, self.frame.size.width - 2*kLabelXOffset, self.frame.size.height))
        self.errorLabel.numberOfLines = 0
        self.errorLabel.textColor = UIColor().errorCellColor()
        self.errorLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        self.errorLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.errorLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(self.errorLabel)

    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    public func setErrorMessage(errorMessage: String) {
        var maxSize : CGSize = CGSizeMake(self.errorLabel.frame.size.width, CGFloat.max)
        
        var textRect : CGRect = (errorMessage as NSString).boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.errorLabel.font], context: nil)
        
        var newSize : CGSize = textRect.size
        
        var viewHeight : CGFloat = newSize.height + 2*kErrorOffset
        if viewHeight < self.minimumHeight {
            viewHeight = self.minimumHeight
        } else {
            viewHeight = self.minimumHeight + 2*kErrorOffset
        }
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight)
        self.errorLabel.text = errorMessage
        self.errorLabel.frame = CGRectMake(self.errorLabel.frame.origin.x, (self.frame.size.height - newSize.height)/2, self.errorLabel.frame.size.width, newSize.height)
    }
    
}