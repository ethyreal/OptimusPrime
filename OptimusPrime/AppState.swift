//
//  AppState.swift
//  OptimusPrime
//
//  Created by George Webster on 3/16/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

struct AppState {

    var count: Int = 0
    var favoritePrimes: [Int] = []
}


enum CounterAction {
    case increment
    case decrement
}

func counterReducer(state: AppState, action: CounterAction) -> AppState {
    var localState = state
    switch action {
    case .increment: localState.count += 1
    case .decrement: localState.count -= 1
    }
    return localState
}
