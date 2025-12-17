//
//  NetworkRequestFactory+Codable.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/9/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Foundation

public extension NetworkRequestFactory {
    func response<T: Decodable>(request: URLRequest,
                              dispatchQueue: DispatchQueue = .main,
                              jsonDecoder: JSONDecoder = JSONDecoder(),
                              completionHandler completion: @Sendable @escaping (Result<Response<T>, Error>) -> Void) -> DataTask {
        return data(request: request, dispatchQueue: dispatchQueue) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                do {
                    let decodedResponse: Response<T> = try response.decode(decoder: jsonDecoder)
                    completion(.success(decodedResponse))
                } catch let decoderError {
                    completion(Result.failure(RequestError.serializationError(error: decoderError)))
                }
            }
        }
    }
    
    func response<T: Decodable>(request: URLRequest,
                                jsonDecoder: JSONDecoder = JSONDecoder()) async throws -> Response<T> {
        let response = try await data(request: request)
        do {
            return try response.decode(decoder: jsonDecoder)
        }
        catch let requestError as RequestError {
            throw requestError
        }
        catch let error {
            throw RequestError.serializationError(error: error)
        }
        
    }
}
