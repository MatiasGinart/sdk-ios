//
//  MPMockServiceBase.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

class MPMockServiceBase {
    required init() {
        
    }

    // Abstract method
    func getCommonData() -> NSData {
        return NSData()
    }

    func getCommonStatusCode() -> UInt32 {
        return 200
    }

    // Abstract method
    func getResponseDataForURLInformation(urlInformation : MPMockURLInformation) -> NSData {
        return NSData()
    }

    func getDataFromFilename(filename : String, ofType type : String) -> NSData {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(filename, ofType: type)!
        return NSData(contentsOfFile:path)!
    }
}
