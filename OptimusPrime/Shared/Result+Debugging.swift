//
//  Result+Debugging.swift
//  OptimusPrime
//
//  Created by George Webster on 2/11/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation


public func trace<T, U>(_ a: Result<T, U>) -> Result<T, U> {
    print("Result: \(a)")
    return a
}

public func trace<T, U>(_ a: T) -> Result<T, U> {
    print("Value: \(a)")
    return .success(a)
}
