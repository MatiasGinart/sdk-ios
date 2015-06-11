//
//  MPOSTestFunctionalCase.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/11/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import XCTest
import MercadoPagoSDKExamples

class MPTestFunctionalCase: KIFTestCase {
    var mockServer : MPMockServer?

    override func setUp() {
        super.setUp()
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.kifNotification, object: nil)

        self.mockServer = MPMockServer()
        
        let selectorString = NSStringFromSelector(self.invocation.selector)
        
        if let finalSelectorName = String.getCapitalizedStringOfString(selectorString, withPrefix:"setUp") {
            let selectorToBeCalled = Selector(finalSelectorName)
            if (self.respondsToSelector(selectorToBeCalled)) {
                let control = UIControl()
                control.sendAction(selectorToBeCalled, to:self, forEvent:nil)
            }
        }
    }
    
    override func tearDown() {
        let selectorString = NSStringFromSelector(self.invocation.selector)
        
        if let finalSelectorName = String.getCapitalizedStringOfString(selectorString, withPrefix:"tearDown") {
            let selectorToBeCalled = Selector(finalSelectorName)
            if (self.respondsToSelector(selectorToBeCalled)) {
                let control = UIControl()
                control.sendAction(selectorToBeCalled, to:self, forEvent:nil)
            }
        }

        NSUserDefaults.standardUserDefaults().removeObjectForKey("manual")

        OHHTTPStubs.removeAllStubs()
        self.mockServer = nil
        super.tearDown()
    }

}
