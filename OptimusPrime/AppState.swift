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
    var favoritePrimes = FavoritePrimes()
    
    struct FavoritePrimes {
        var items: [Int] = []
        
        var count: Int { items.count }
    }
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

func counterReducer(state: inout Int, action: AppAction) {
    switch action {
    case .counter(.increment): state += 1
    case .counter(.decrement): state -= 1
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
        state.favoritePrimes.items.append(state.count)
    case .isPrimeModel(.remove):
        let last = state.count
        state.favoritePrimes.items.removeAll(where: { $0 == state.count })
    default: break
    }

}

enum FavoritePrimeAction {
    case removeFrom(IndexSet)
}

func favoritePrimeReducer(state: inout AppState.FavoritePrimes, action: AppAction) {
    switch action {
    case .favoritePrime(.removeFrom(let indexSet)):
        for index in indexSet {
            state.items.remove(at: index)
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

func pullback<LocalValue, GlobalValue, Action>(_ reducer: @escaping (inout LocalValue, Action) -> Void, valuePath: WritableKeyPath<GlobalValue, LocalValue>) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        reducer(&globalValue[keyPath: valuePath], action)
    }
}

let appReducer = combine(pullback(counterReducer, valuePath: \.count),
                         isPrimeModelReducer,
                         pullback(favoritePrimeReducer, valuePath: \.favoritePrimes))


