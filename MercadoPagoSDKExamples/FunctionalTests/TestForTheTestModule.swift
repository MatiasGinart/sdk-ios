//
//  TestForTheTestModule.swift
//  MercadoPagoSDKExamples
//
//  Created by Matías Ginart on 6/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import XCTest
import MercadoPagoSDKExamples

class TestForTheTestModule: MPTestFunctionalCase {

    func testTestForTheTestModuleShouldBeWorking() {
        // TEEEEES

        self.tester.waitForViewWithAccessibilityLabel("EXAMPLES_VIEW")
        self.tester.tapViewWithAccessibilityLabel("EXAMPLES_TABLE_VIEW")
        self.tester.tapRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), inTableViewWithAccessibilityIdentifier: "EXAMPLES_TABLE_VIEW")
        self.tester.waitForTimeInterval(1)
    }

    func testTestForTheTestModuleShouldBeWorking2() {
        self.tester.waitForViewWithAccessibilityLabel("EXAMPLES_VIEW")
        self.tester.tapViewWithAccessibilityLabel("EXAMPLES_TABLE_VIEW")
        self.tester.tapRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), inTableViewWithAccessibilityIdentifier: "EXAMPLES_TABLE_VIEW")
        self.tester.waitForTimeInterval(1)
    }

}
