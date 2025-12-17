//
//  NetworkRequestFactory+Combine.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/7/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation
import Combine

public extension NetworkRequestFactory {
    
    func response<CodableData: Codable>(urlRequest: URLRequest,
                                        jsonDecoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<CodableData>, Error> {
        return dataPublisher(request: urlRequest)
            .tryMap { try $0.decode(decoder: jsonDecoder) }
            .mapError {
                if $0 is Swift.DecodingError { return RequestError.serializationError(error: $0) }
                return $0
            }
            .eraseToAnyPublisher()
    }
}
