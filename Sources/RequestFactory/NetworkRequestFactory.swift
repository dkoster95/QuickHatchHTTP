//
//  NetworkRequestFactory.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/25/17.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Foundation
import Combine

public protocol NetworkRequestFactory {
    func data(request: URLRequest,
              dispatchQueue: DispatchQueue,
              completionHandler completion: @Sendable @escaping (Result<HTTPResponse, Error>) -> Void) -> DataTask
    
    func dataPublisher(request: URLRequest) -> AnyPublisher<HTTPResponse,Error>
    
    func data(request: URLRequest) async throws -> HTTPResponse
}
