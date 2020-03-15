//
//  WolframAlpha.swift
//  OptimusPrime
//
//  Created by George Webster on 2/14/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

struct WolframAlphaDTO: Decodable {
    let queryresult: QueryResult
    
    struct QueryResult: Decodable {
        let pods: [Pod]
        
        struct Pod: Decodable {
            let primary: Bool?
            let subpods: [SubPod]
            
            struct SubPod: Decodable {
                let plaintext: String
            }
        }
    }
}

extension WolframAlphaDTO {
    
    static func makeFromData(_ data: Data) -> Result<WolframAlphaDTO, Error> {
        Result {
            try JSONDecoder().decode(WolframAlphaDTO.self, from: data)
        }
    }
}


protocol WolframDataTransport: DataTransport {
    
    var wolframeAppKey: String? { get }
}

extension URLSession: WolframDataTransport {
    var wolframeAppKey: String? {
        Configuration.wolframAppID
    }
}

enum WolframError: Error {
    case failedToLoadAppID
    case failedToParsePrime
}

func wolframAlphaQuery(_ transport: WolframDataTransport, _ query:String, callback: @escaping (Result<WolframAlphaDTO, Error>) -> Void) {
    guard let appID = transport.wolframeAppKey else {
        callback(.failure(WolframError.failedToLoadAppID))
        return
    }
    var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
    components.queryItems = [
        URLQueryItem(name: "input", value: query),
        URLQueryItem(name: "format", value: "plaintext"),
        URLQueryItem(name: "output", value: "JSON"),
        URLQueryItem(name: "appid", value: appID),
    ]

    transport.loadRequest(URLRequest(url: components.url!)) { (result) in
        let response = result.flatMap(WolframAlphaDTO.makeFromData)
        
        DispatchQueue.main.async {
            callback(response)
        }
    }
}

func nthPrime(_ transport: WolframDataTransport, _ n: Int, callback: @escaping (Result<Int, Error>) -> Void) {
    wolframAlphaQuery(transport, "Prime \(n)") { (result) in
        let parsedPrime: Result<Int, Error> = result.flatMap {
            if let value = $0.queryresult
                .pods
                .first(where: { $0.primary == .some(true) })?
                .subpods
                .first?
                .plaintext, let prime = Int(value) {
                return .success(prime)
            } else {
                return .failure(WolframError.failedToParsePrime)
            }
        }
        callback(parsedPrime)
    }
}
