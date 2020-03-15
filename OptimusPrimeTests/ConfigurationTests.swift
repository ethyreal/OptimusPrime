//
//  ConfigurationTests.swift
//  OptimusPrimeTests
//
//  Created by George Webster on 2/14/20.
//  Copyright © 2020 George Webster. All rights reserved.
//

import XCTest
@testable import OptimusPrime

class ConfigurationTests: XCTestCase {

    func testLoadFromJson() {
        
        let sut = dataFromJsonFile("optimusprime_configuration", in: Bundle(for: AppDelegate.self))
            .flatMap(Configuration.makeFromData)
        
        switch sut {
        case .success(let config):
            XCTAssertNotNil(config.wolframAppID)
            XCTAssertFalse(config.wolframAppID.isEmpty)
            XCTAssert(config.wolframAppID != "replace-me-with-real-id")
        case .failure(let error):
            XCTFail("failed to load config with error: \(error.localizedDescription)")
        }
    }
}
