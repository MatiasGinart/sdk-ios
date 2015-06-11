//
//  MPOSTestHelper.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

class MPTestHelper {
    class func setAccessibilityId(accesibilityId : String, forObject unwrappedObject: NSObject?) {

        #if DEBUG
            if let object = unwrappedObject {
                let accessibilityLabelSelector = Selector("setAccessibilityLabel:")
                if object.respondsToSelector(accessibilityLabelSelector) {
                    object.accessibilityLabel = accesibilityId
                }
                
                if object is UIView {
                    let accessibilityIdentificationObject = object as! UIView
                    accessibilityIdentificationObject.accessibilityIdentifier = accesibilityId
                }
            }
        #endif
        
    }
}