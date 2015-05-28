//
//  ErrorTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 7/4/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import UIKit

public class ErrorTableViewCell : UITableViewCell {
    var errorView : GenericErrorView?
    public var height : CGFloat = 0
    
    public func setError(error: String?) {
        if error == nil {
            if self.errorView != nil {
                self.errorView!.removeFromSuperview()
            }
            self.errorView == nil
        } else {
            self.errorView = GenericErrorView(frame: CGRectMake(0, height, self.frame.width, 0))
            self.errorView!.setErrorMessage(error!)
            self.addSubview(self.errorView!)
        }
    }
	
	public func focus() {
	}
    
    public func hasError() -> Bool {
        return self.errorView != nil
    }
    
    public func getHeight() -> CGFloat {
        var error : CGFloat = 0
        if self.hasError() {
            error = self.errorView!.frame.height
        }
        return error + height
    }
}