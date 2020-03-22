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
    
    var user: User? = nil
    
    var activityFeed: [Activity] = []
    
    struct User {
        let id: Int
        let name: String
        let bio: String
    }
    
    struct Activity {
        let timestamp: Date
        let activityType: ActivityType
        
        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }
    
}

extension AppState.Activity {
    init(of type: ActivityType) {
        self.timestamp = Date()
        self.activityType = type
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
        state.favoritePrimes.append(state.count)
    case .remove:
        state.favoritePrimes.removeAll(where: { $0 == state.count })
    }
}

enum FavoritePrimeAction {
    case removeFrom(IndexSet)
}

func favoritePrimeReducer(state: inout [Int], action: FavoritePrimeAction) {
    switch action {
    case .removeFrom(let indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}

func activityFeedReducer(_ reducer: @escaping (inout AppState, AppAction) -> Void) -> (inout AppState, AppAction) -> Void {
    
    return { state, action in
        
        switch action {
        case .counter: break
        case .isPrimeModal(.remove):
            state.activityFeed.append(.init(of: .removedFavoritePrime(state.count)))
        case .isPrimeModal(.add):
            state.activityFeed.append(.init(of: .addedFavoritePrime(state.count)))
        case .favoritePrime(.removeFrom(let indexSet)):
            for index in indexSet {
                state.activityFeed.append(.init(of: .removedFavoritePrime(index)))
            }
        }
        reducer(&state, action)
    }
}

func loggingReducer(_ reducer: @escaping (inout AppState, AppAction) -> Void) -> (inout AppState, AppAction) -> Void {
    return { state, action in
        reducer(&state, action)
        print("---")
        print("Action: \(action)")
        print("State:")
        dump(state)
        print("---")

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


let userActionsReducer: (inout AppState, AppAction) -> Void = combine(pullback(counterReducer, valuePath: \.count, actionPath: \.counter),
                                 pullback(isPrimeModelReducer, valuePath: \.self, actionPath: \.isPrimeModal),
                                 pullback(favoritePrimeReducer, valuePath: \.favoritePrimes, actionPath: \.favoritePrimes))

//let appReducer = loggingReducer(activityFeedReducer(userActionsReducer))
let appReducer = userActionsReducer
                    |> activityFeedReducer
                    |> loggingReducer


