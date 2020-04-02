//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by George Webster on 4/2/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation
import Combine

public final class ObservableStore<Value, Action>: ObservableObject {
    
    private let reducer: (inout Value, Action) -> Void
    
    @Published public private(set) var value: Value
    
    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    public func send(_ action: Action) {
        reducer(&value, action)
    }
}


public func combine<State, Action>(_ reducers: (inout State, Action) -> Void...) -> (inout State, Action) -> Void {
    return { state, action in
        reducers.forEach { reducer in
            reducer(&state, action)
        }
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(_ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
                                                                  valuePath: WritableKeyPath<GlobalValue, LocalValue>,
                                                                  actionPath: KeyPath<GlobalAction, LocalAction?>) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: actionPath] else { return }
        reducer(&globalValue[keyPath: valuePath], localAction)
    }
}
