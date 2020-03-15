//
//  JsonConversion.swift
//  OptimusPrime
//
//  Created by George Webster on 2/11/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation


public typealias JsonDictionary = [String: Any]


public func dataFromJsonFile(_ fileName: String, in bundle: Bundle) -> Result<Data, Error> {
    return urlForJsonFile(fileName, in: bundle)
        .flatMap(trace)
        .flatMap(dataForURL)
}

public func dataForURL(_ url: URL) -> Result<Data, Error> {
    Result { try Data(contentsOf: url) }
}

public func jsonDictionaryFromJsonFile(_ fileName: String, in bundle: Bundle = Bundle.main) -> Result<JsonDictionary, Error> {
    return dataFromJsonFile(fileName, in: bundle)
        .flatMap(jsonDictionaryFromData)
}

public func jsonDictionaryFromData(_ data: Data) -> Result<JsonDictionary, Error> {
    return data.toJsonDictionary()
}

enum JSONError: Error {
    case dictionaryConversion
    case stringSerialization
}

extension Data {
    
    public func toJsonDictionary(options: JSONSerialization.ReadingOptions = .mutableContainers) -> Result<JsonDictionary, Error> {
        return Result {
            let obj = try JSONSerialization.jsonObject(with: self, options: options)
            guard let json = obj as? JsonDictionary else { throw JSONError.dictionaryConversion }
            return json
        }
    }
}
