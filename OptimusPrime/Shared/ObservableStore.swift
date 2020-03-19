//
//  ObservableStore.swift
//  OptimusPrime
//
//  Created by George Webster on 3/16/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation
import Combine

final class ObservableStore<Value, Action>: ObservableObject {
    
    let reducer: (Value, Action) -> Value
    
    @Published var value: Value
    
    init(initialValue: Value, reducer: @escaping (Value, Action) -> Value) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        self.value = reducer(value, action)
    }
}
