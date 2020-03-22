//
//  ForwardApplication.swift
//  OptimusPrime
//
//  Created by George Webster on 3/22/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

//MARK:- Forward Application

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication


public func |> <A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}

public func apply<A, B>(_ x: A, to f: (A) -> B) -> B {
    return f(x)
}

