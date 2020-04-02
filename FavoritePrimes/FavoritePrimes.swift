//
//  FavoritePrimes.swift
//  FavoritePrimes
//
//  Created by George Webster on 4/2/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

public enum FavoritePrimeAction {
    case removeFrom(IndexSet)
}

public func favoritePrimeReducer(state: inout [Int], action: FavoritePrimeAction) {
    switch action {
    case .removeFrom(let indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}

