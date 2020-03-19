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
    case isPrimeModel(IsPrimeAction)
    case favoritePrime(FavoritePrimeAction)
}

enum CounterAction {
    case increment
    case decrement
}

func counterReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .counter(.increment): state.count += 1
    case .counter(.decrement): state.count -= 1
    default: break
    }

}

enum IsPrimeAction {
    case add
    case remove
}

func isPrimeModelReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .isPrimeModel(.add):
        state.favoritePrimes.append(state.count)
    case .isPrimeModel(.remove):
        state.favoritePrimes.removeAll(where: { $0 == state.count })
    default: break
    }

}

enum FavoritePrimeAction {
    case removeFrom(IndexSet)
}

func favoritePrimeReducer(state: inout AppState, action: AppAction) {
    switch action {
    case .favoritePrime(.removeFrom(let indexSet)):
        for index in indexSet {
            state.favoritePrimes.remove(at: index)
        }
    default: break
    }
}

func combine(_ reducers: (inout AppState, AppAction) -> Void...) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        reducers.forEach { reducer in
            reducer(&state, action)
        }
    }
}

let appReducer = combine(counterReducer,
                         isPrimeModelReducer,
                         favoritePrimeReducer)
