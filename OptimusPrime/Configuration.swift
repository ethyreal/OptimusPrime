//
//  Configuration.swift
//  OptimusPrime
//
//  Created by George Webster on 2/14/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation


struct Configuration: Codable {
    
    var wolframAppID: String
}

extension Configuration {
    
    static func makeFromData(_ data: Data) -> Result<Configuration, Error> {
        Result {
            try JSONDecoder().decode(Configuration.self, from: data)
        }
    }
}

extension Configuration {
    
    static var wolframAppID: String? = {
        try? dataFromJsonFile("optimusprime_configuration", in: Bundle(for: AppDelegate.self))
            .flatMap(Configuration.makeFromData).get().wolframAppID
    }()
}
