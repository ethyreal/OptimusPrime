//
//  Counter.swift
//  Counter
//
//  Created by George Webster on 4/2/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

public enum CounterAction {
    case increment
    case decrement
}

public func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .increment: state += 1
    case .decrement: state -= 1
    }

}

