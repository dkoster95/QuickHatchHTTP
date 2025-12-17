//
//  HTTPRespone.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/13/25.
//

import Foundation

public protocol HTTPResponse {
    var statusCode: HTTPStatusCode { get }
    var headers: [AnyHashable: Any] { get }
    var body: Data? { get }
}

public extension HTTPResponse {
    func decode<T: Decodable>(decoder: JSONDecoder) throws -> Response<T> {
        if let body = body {
            let decodedBody = try decoder.decode(T.self, from: body)
            return Response(data: decodedBody, statusCode: statusCode, headers: headers)
        }
        throw RequestError.noResponse
    }
}

public struct QHHTTPResponse: HTTPResponse {
    public let statusCode: HTTPStatusCode
    public let headers: [AnyHashable : Any]
    public let body: Data?
    
    public init(body: Data?, urlResponse: URLResponse) {
        self.body = body
        self.headers = (urlResponse as? HTTPURLResponse)?.allHeaderFields ?? [:]
        self.statusCode = HTTPStatusCode(rawValue: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1) ?? .serviceUnavailable
    }
}

public struct Response<Value> {
    public let data: Value
    public let statusCode: HTTPStatusCode
    public let headers: [AnyHashable: Any]
    
    public init(data: Value,
                statusCode: HTTPStatusCode,
                headers: [AnyHashable: Any]) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
    
    public func map<NewValue>(transform: (Value) -> NewValue) -> Response<NewValue> {
        return Response<NewValue>(data: transform(data), statusCode: statusCode, headers: headers)
    }
    
    public func flatMap<NewValue> (transform: (Value) -> Response<NewValue>) -> Response<NewValue> {
        return transform(data)
    }
    
    public func filter(query: (Value) -> Bool) -> Response<Value?> {
        return query(data) ? Response<Value?>(data: data, statusCode: statusCode, headers: headers) : Response<Value?>(data: nil, statusCode: statusCode, headers: headers)
    }
}
