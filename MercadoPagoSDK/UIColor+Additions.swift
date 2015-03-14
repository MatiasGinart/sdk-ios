//
//  UIColor+Additions.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func greenOkColor() -> UIColor
    {
    return UIColorFromRGB(0x6FBB2A)
    }
    
    func redFailureColor() -> UIColor
    {
    return UIColorFromRGB(0xB94A48)
    }
    
    //should say red at the begining?
    func errorValidationTextColor() -> UIColor
    {
    return UIColorFromRGB(0xB34C42)
    }
    
    func yellowFailureColor() -> UIColor
    {
    return UIColorFromRGB(0xF5CC00)
    }
    
    func blueMercadoPago() -> UIColor
    {
    return UIColorFromRGB(0x00B2EB)
    }
    
    func grayBaseText() -> UIColor
    {
    return UIColorFromRGB(0x333333)
    }
    
    func grayDark() -> UIColor
    {
    return UIColorFromRGB(0x666666)
    }
    
    func grayLight() -> UIColor
    {
    return UIColorFromRGB(0x999999)
    }
    
    func grayLines() -> UIColor
    {
    return UIColorFromRGB(0xCCCCCC)
    }
    
    func backgroundColor() -> UIColor
    {
    return UIColorFromRGB(0xEBEBF0)
    }
    
    func white() -> UIColor
    {
    return UIColorFromRGB(0xFFFFFF)
    }
    
    func installments() -> UIColor {
        return UIColorFromRGB(0x2BA2EC)
    }
}