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

enum AppAction {
    case counter(CounterAction)
    case favoritePrime(FavoritePrimeAction)
}

enum CounterAction {
    case increment
    case decrement
}

enum FavoritePrimeAction {
    case add
    case remove
    case removeFrom(IndexSet)
}

func appActionReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .counter(.increment): state.count += 1
    case .counter(.decrement): state.count -= 1
        
    case .favoritePrime(.add):
        state.favoritePrimes.append(state.count)
    case .favoritePrime(.remove):
        state.favoritePrimes.removeAll(where: { $0 == state.count })
    case .favoritePrime(.removeFrom(let indexSet)):
        for index in indexSet {
            state.favoritePrimes.remove(at: index)
        }
    }
}
