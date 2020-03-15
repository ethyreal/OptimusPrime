//
//  URLRequest+Headers.swift
//  OptimusPrime
//
//  Created by George Webster on 2/11/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation


extension URLRequest {
    
    subscript(header header: String) -> String? {
        get {
            value(forHTTPHeaderField: header)
        }
        set {
            setValue(newValue, forHTTPHeaderField: header)
        }
    }
}
