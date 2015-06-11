//
//  IdentificationServiceTest.swift
//  MercadoPagoSDKExamples
//
//  Created by Matías Ginart on 6/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit
import XCTest
import MercadoPagoSDK

class IdentificationServiceTest: MPBaseTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func setUpTestIdentificationServiceShouldReturnFailIfServiceIsNot200() {
        // Preguntar: en point es api.mercadolibre, aca api.mercadopago
        self.mockServer!.registerURL(MPMockURLInformation(aPath:"https://api.mercadopago.com/identification_types", aRestMethod: .GET, aCaseKey:MPMockServiceIdentificationType.error, aStatusCode:400, aService:MPMockServiceIdentificationType.self))
        self.mockServer!.stubNetworking()
    }

    func testIdentificationServiceShouldReturnFailIfServiceIsNot200() {
        let service = IdentificationService(baseURL: "https://api.mercadopago.com")
        self.expectationForNotification("testIdentificationServiceShouldReturnFailIfServiceIsNot200", object: nil, handler: nil)

        service.getIdentificationTypes(public_key: nil, privateKey: nil, success: {(jsonResult: AnyObject?) -> Void in
            XCTAssertTrue(false, "no deberia pasar por aca")
        }, failure: {(error: NSError) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("testIdentificationServiceShouldReturnFailIfServiceIsNot200", object: nil)
            XCTAssertTrue(true, "joyaaaaa")
        })

        self.waitForExpectationsWithTimeout(0.4, handler: nil)
    }
}
