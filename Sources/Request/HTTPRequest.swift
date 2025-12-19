//
//  HTTPRequest.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/13/25.
//
import Foundation
import Combine

public protocol DataTask: NSObjectProtocol {
    func resume()
    func suspend()
    func cancel()
}

public protocol HTTPRequest {
    var headers: [String: String] { get }
    var body: Data? { get }
    var url: String { get }
    var method: HTTPMethod { get }
}

public protocol HTTPRequestActionable {
    func response() async throws -> HTTPResponse
    var responsePublisher: any Publisher<HTTPResponse, Error> { get }
}

public protocol HTTPRequestDecodedActionable<ResponseType> {
    associatedtype ResponseType: Codable
    func responseDecoded() async throws -> Response<ResponseType>
    var responseDecodedPublisher: any Publisher<ResponseType, Error> { get }
}

public struct QHHTTPRequest<T: Codable>: HTTPRequest, URLRequestProtocol, HTTPRequestActionable, HTTPRequestDecodedActionable {
    public typealias ResponseType = T
    
    public let headers: [String : String]
    public let body: Data?
    public let url: String
    public let method: HTTPMethod
    private let requestFactory: NetworkRequestFactory
    private let jsonDecoder: JSONDecoder
    
    public init(headers: [String : String] = [:],
                body: Data? = nil,
                url: String,
                method: HTTPMethod,
                requestFactory: NetworkRequestFactory = URLSessionRequestFactory(urlSession: URLSession.shared),
                jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.headers = headers
        self.body = body
        self.url = url
        self.method = method
        self.requestFactory = requestFactory
        self.jsonDecoder = jsonDecoder
    }
    
    public func response() async throws -> any HTTPResponse {
        let urlRequest = try asURLRequest()
        return try await requestFactory.data(request: urlRequest)
    }
    
    public func responseDecoded() async throws -> Response<T> {
        let urlRequest = try asURLRequest()
        return try await requestFactory.response(request: urlRequest, jsonDecoder: jsonDecoder)
    }
    
    public var responseDecodedPublisher: any Publisher<T, Error> {
        guard let urlRequest = try? asURLRequest() else { return Fail(error: RequestError.malformedRequest) }
        return requestFactory.response(urlRequest: urlRequest,
                                       jsonDecoder: jsonDecoder)
        .map { $0.data }
    }
    public var responsePublisher: any Publisher<any HTTPResponse, Error> {
        guard let urlRequest = try? asURLRequest() else { return Fail(error: RequestError.malformedRequest) }
        return requestFactory.dataPublisher(request: urlRequest)
    }
    
    public func asURLRequest() throws -> URLRequest {
        return try URLRequest(url: url, method: method, headers: headers)
    }
}
