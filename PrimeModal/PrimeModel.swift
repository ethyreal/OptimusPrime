//
//  PrimeModel.swift
//  PrimeModal
//
//  Created by George Webster on 4/2/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

public struct PrimeModalState {
    public var count: Int
    public var favoritePrimes:[ Int]
    
}

extension PrimeModalState {
    public init(count: Int, favorites: [Int]) {
        self.init(count: count, favoritePrimes: favorites)
    }
}

public enum IsPrimeAction {
    case add
    case remove
}

public func isPrimeModelReducer(state: inout PrimeModalState, action: IsPrimeAction) {
    switch action {
    case .add:
        state.favoritePrimes.append(state.count)
    case .remove:
        state.favoritePrimes.removeAll(where: { $0 == state.count })
    }
}
