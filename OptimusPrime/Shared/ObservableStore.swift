//
//  ObservableStore.swift
//  OptimusPrime
//
//  Created by George Webster on 3/16/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation
import Combine

final class ObservableStore<T>: ObservableObject {
    
    @Published var value: T
    
    init(initialValue: T) {
        self.value = initialValue
    }
}
