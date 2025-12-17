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
    associatedtype ResponseType: Codable
    func response(queue: DispatchQueue) async -> Result<ResponseType, RequestError>
    var responsePublisher: any Publisher<Result<ResponseType, RequestError>, Never> { get }
}

public struct QHHTTPRequest: HTTPRequest, URLRequestProtocol {
    public let headers: [String : String]
    public let body: Data?
    public let url: String
    public let method: HTTPMethod
    
    public init(headers: [String : String] = [:],
                body: Data? = nil,
                url: String,
                method: HTTPMethod) {
        self.headers = headers
        self.body = body
        self.url = url
        self.method = method
    }
    
    public func asURLRequest() throws -> URLRequest {
        return try URLRequest(url: url, method: method, headers: headers)
    }
}
