//
//  DataTransport.swift
//  OptimusPrime
//
//  Created by George Webster on 2/12/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import Foundation

protocol DataTransport {
    
    func loadRequest(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

enum DataTransportError: Error {
    case invalidUrl
    case invalidData
    case invalidResponse
}

extension URLSession: DataTransport {
    func loadRequest(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = dataTask(with: request) { (data, response, error) in
            let result = validateErrors((data, response, error))
                    .flatMap(validateResponse)
                    .flatMap(validateData)
                    .map(dataFromResponseDTO)
            completion(result)
        }
        task.resume()
    }
}


//MARK:- Response Parsing

func validateErrors(_ responseDTO: (Data?, URLResponse?, Error?)) -> Result<(Data?, URLResponse?), Error> {
    let (data, response, error) = responseDTO
    switch error {
    case .some(let systemError): return .failure(systemError)
    case .none: return .success((data, response))
    }
}

func validateResponse(_ responseDTO: (Data?, URLResponse?)) -> Result<(Data?, URLResponse), Error> {
    let (data, response) = responseDTO
    guard let urlResponse = response else {
        return .failure(DataTransportError.invalidResponse)
    }
    return .success((data, urlResponse))
}

func validateData(_ responseDTO: (Data?, URLResponse)) -> Result<(Data, URLResponse), Error> {
    let (data, response) = responseDTO
    guard let validData = data else {
        return .failure(DataTransportError.invalidData)
    }
    return .success((validData, response))
}

func dataFromResponseDTO(_ responseDTO:(Data, URLResponse)) -> Data {
    responseDTO.0
}
