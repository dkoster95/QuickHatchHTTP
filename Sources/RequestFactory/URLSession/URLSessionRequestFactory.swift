//
//  URLSessionLayer.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/25/17.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Foundation
import Combine

public final class URLSessionRequestFactory: NetworkRequestFactory {    
    private let session: URLSessionProtocol
    
    public init(urlSession: URLSessionProtocol) {
        self.session = urlSession
    }
    
    public func data(request: URLRequest,
                     dispatchQueue: DispatchQueue,
                     completionHandler completion: @Sendable @escaping (Result<HTTPResponse, Error>) -> Void) -> DataTask {
        return session.task(with: request) { (data: Data?,response: URLResponse?,error: Error?) in
            dispatchQueue.async {
                if let requestError = NetworkRequestFactoryErrorValidator.validate(data: data,
                                                                                   response: response,
                                                                                   error: error) {
                    completion(Result.failure(requestError))
                    return
                }
                guard let data = data, let urlResponse = response else {
                    completion(Result.failure(RequestError.noResponse))
                    return
                }
                let response = QHHTTPResponse(body: data, urlResponse: urlResponse)
                completion(.success(response))
            }
        }
    }

    public func dataPublisher(request: URLRequest) -> AnyPublisher<HTTPResponse,Error> {
        return session.taskPublisher(for: request)
            .tryMap { response in
                if let requestError = NetworkRequestFactoryErrorValidator.validate(data: response.data,
                                                                                   response: response.response) {
                    throw requestError
                }
                let httpResponse = QHHTTPResponse(body: response.data, urlResponse: response.response)
                return httpResponse
            }
            .mapError { RequestError.map(error: $0) }
            .eraseToAnyPublisher()
    }
    
    public func data(request: URLRequest) async throws -> HTTPResponse {
        do {
            let response = try await session.task(request: request)
            let httpResponse = QHHTTPResponse(body: response.0, urlResponse: response.1)
            if let requestError = NetworkRequestFactoryErrorValidator.validate(data: response.0, response: response.1) {
                throw requestError
            }
            return httpResponse
        }
        catch let requestError as RequestError {
            throw requestError
        }
        catch let error {
            if let requestError = NetworkRequestFactoryErrorValidator.validate(data: nil, response: nil, error: error) {
                throw requestError
            }
            throw RequestError.other(error: error)
        }
    }
}
