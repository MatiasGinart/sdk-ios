//
//  MPMockServiceRules.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/12/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation

class MPMockServiceRules: NSObject {
    static let rules : Dictionary <String, MPMockServiceBase.Type> = [
        "https://api.mercadolibre.com/identification_types_GET" : MPMockServiceIdentificationType.self
    ]
}
