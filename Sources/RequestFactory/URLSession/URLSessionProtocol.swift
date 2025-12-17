//
//  URLSessionProtocol.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/7/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation
import Combine

public protocol URLSessionProtocol {
    func task(with request: URLRequest, completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask
    
    func task(request: URLRequest) async throws -> (Data, URLResponse)
    
    func taskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSessionDataTask: DataTask {
    open override func resume() {
        self.resume()
    }
    
    open override func cancel() {
        self.cancel()
    }
    
    open override func suspend() {
        self.suspend()
    }
}

extension URLSession: URLSessionProtocol {

    public func task(request: URLRequest) async throws -> (Data, URLResponse) {
        return try await data(for: request)
    }
    
    public func task(with request: URLRequest,
                     completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask {
        return self.dataTask(with: request, completionHandler: completionHandler)
    }
    
    public func taskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
