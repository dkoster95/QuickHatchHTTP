//
//  URLConvertible.swift
//  QuickHatch
//
//  Created by Daniel Koster on 10/25/17.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public protocol URLConvertible: Sendable {
    func asURL() throws -> URL
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw EncodingError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLConvertible {
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {

    public func asURL() throws -> URL {
        guard let url = url else { throw EncodingError.invalidURL(url: self) }
        return url
    }
}

public protocol URLRequestProtocol {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestProtocol {
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestProtocol {
    public func asURLRequest() throws -> URLRequest { return self }
}

extension URLRequest {
    public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()
        
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}
