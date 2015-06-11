//
//  XCTest+KIF.swift
//  MPSeller
//
//  Created by Matías Ginart on 5/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    
    var tester: KIFUITestActor { return tester() }
    var system: KIFSystemTestActor { return system() }
    
    private func tester(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    private func system(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
    
}

extension KIFTestActor {
    
    var tester: KIFUITestActor { return tester() }
    var system: KIFSystemTestActor { return system() }
    
    private func tester(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }
    
    private func system(_ file : String = __FILE__, _ line : Int = __LINE__) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
    
}