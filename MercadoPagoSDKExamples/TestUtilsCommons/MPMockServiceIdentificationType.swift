//
//  MPMockServiceIdentificationType.swift
//  MPSeller
//
//  Created by Matías Ginart on 6/10/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit

class MPMockServiceIdentificationType: MPMockServiceBase {
    static let success = "success"
    static let error = "error"

    override func getCommonData() -> NSData {
        return self.getDataFromFilename("identification_type_success", ofType: "json")
    }
    
    override func getResponseDataForURLInformation(urlInformation : MPMockURLInformation) -> NSData {
        if urlInformation.caseKey == MPMockServiceIdentificationType.error {
            return NSData()
        } else {
            return self.getCommonData()
        }
    }
}
