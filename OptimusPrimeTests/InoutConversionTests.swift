//
//  InoutConversionTests.swift
//  OptimusPrimeTests
//
//  Created by George Webster on 2/14/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import XCTest
@testable import OptimusPrime


/**
 Prove the equivalence between `(A) -> A` and `(inout A) -> Void`
 */

func toInout<A>(_ f: @escaping (A) -> A) -> (inout A) -> Void {
    return { a in
        a = f(a)
    }
}

func fromInout<A>(_ f: @escaping (inout A) -> Void) -> (A) -> A {
    return { a in
        var b = a
        f(&b)
        return b
    }
}


class InoutConversionTests: XCTestCase {}


func addOne(_ x: Int) -> Int {
    x + 1
}

extension InoutConversionTests {
    func testToInout() {
        
        XCTAssert(addOne(1) == 2)
        var sut = 0
        toInout(addOne)(&sut)
        XCTAssert(sut == 1)
    }
}

func addedOne(_ x: inout Int) {
    x += 1
}

extension InoutConversionTests {
    func testFromInout() {
        var sut = 1
        addedOne(&sut)
        XCTAssert(sut == 2)
        XCTAssert(fromInout(addedOne)(sut) == 3)
        XCTAssert(sut == 2)
    }
}
