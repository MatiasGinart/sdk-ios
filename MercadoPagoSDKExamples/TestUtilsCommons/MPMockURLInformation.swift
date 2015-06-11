//
//  MPMockURLInformation.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

public enum MPOSHTTPMethod {
    case GET
    case POST
    case PUT
    case DELETE
    
    public func stringify() -> String {
        switch(self) {
        case POST: return "POST"
        case GET: return "GET"
        case PUT: return "PUT"
        case DELETE: return "DELETE"
        }
    }
}

class MPMockURLInformation {
    let path : String
    let restMethod : MPOSHTTPMethod
    let caseKey : String
    // TODO: Ver si se puede levantar con reflection cuando ande en swift y sacar esta asquerosidad de aca
    let service : MPMockServiceBase.Type
    var timeInterval : UInt32?
    var statusCode : Int32

    init (aPath : String, aRestMethod : MPOSHTTPMethod, aCaseKey : String, aStatusCode : Int32, aService : MPMockServiceBase.Type) {
        self.path = aPath
        self.restMethod = aRestMethod
        self.caseKey = aCaseKey
        self.service = aService
        self.statusCode = aStatusCode
    }

    convenience init (aPath : String, aRestMethod : MPOSHTTPMethod, aCaseKey : String, aStatusCode : Int32, aTimeInterval : UInt32, aService : MPMockServiceBase.Type) {
        self.init(aPath: aPath, aRestMethod: aRestMethod, aCaseKey: aCaseKey, aStatusCode: aStatusCode, aService: aService)
        self.timeInterval = aTimeInterval
    }
}