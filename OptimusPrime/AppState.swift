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
    case isPrimeModal(IsPrimeAction)
    case favoritePrime(FavoritePrimeAction)
    
    var counter: CounterAction? {
        guard case let .counter(value) = self else { return nil }
        return value
    }
    
    var isPrimeModal: IsPrimeAction? {
        guard case let .isPrimeModal(value) = self else { return nil }
        return value
    }
    
    var favoritePrimes: FavoritePrimeAction? {
        guard case let .favoritePrime(value) = self else { return nil }
        return value
    }
}

enum CounterAction {
    case increment
    case decrement
}

func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .increment: state += 1
    case .decrement: state -= 1
    }

}

enum IsPrimeAction {
    case add
    case remove
}

func isPrimeModelReducer(state: inout AppState, action: IsPrimeAction) {
    switch action {
    case .add:
        state.favoritePrimes.items.append(state.count)
    case .remove:
        state.favoritePrimes.items.removeAll(where: { $0 == state.count })
    default: break
    }

}

enum FavoritePrimeAction {
    case removeFrom(IndexSet)
}

func favoritePrimeReducer(state: inout AppState.FavoritePrimes, action: FavoritePrimeAction) {
    switch action {
    case .removeFrom(let indexSet):
        for index in indexSet {
            state.items.remove(at: index)
        }
    }
}

func combine(_ reducers: (inout AppState, AppAction) -> Void...) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        reducers.forEach { reducer in
            reducer(&state, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(_ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
                                                                  valuePath: WritableKeyPath<GlobalValue, LocalValue>,
                                                                  actionPath: KeyPath<GlobalAction, LocalAction?>) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: actionPath] else { return }
        reducer(&globalValue[keyPath: valuePath], localAction)
    }
}


let appReducer = combine(pullback(counterReducer, valuePath: \.count, actionPath: \.counter),
                         pullback(isPrimeModelReducer, valuePath: \.self, actionPath: \.isPrimeModal),
                         pullback(favoritePrimeReducer, valuePath: \.favoritePrimes, actionPath: \.favoritePrimes))


