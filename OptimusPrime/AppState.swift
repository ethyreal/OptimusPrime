//
//  AppState.swift
//  OptimusPrime
//
//  Created by George Webster on 3/16/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Counter
import PrimeModal
import FavoritePrimes

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

extension AppState {
    
    var primeModelState: PrimeModalState {
        get {
            PrimeModalState(
                count: count,
                favorites: favoritePrimes)
        }
        set {
            count = newValue.count
            favoritePrimes = newValue.favoritePrimes
        }
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


let userActionsReducer: (inout AppState, AppAction) -> Void = combine(pullback(counterReducer, valuePath: \.count, actionPath: \.counter),
                                 pullback(isPrimeModelReducer, valuePath: \.primeModelState, actionPath: \.isPrimeModal),
                                 pullback(favoritePrimeReducer, valuePath: \.favoritePrimes, actionPath: \.favoritePrimes))

//let appReducer = loggingReducer(activityFeedReducer(userActionsReducer))
let appReducer = userActionsReducer
                    |> activityFeedReducer
                    |> loggingReducer


