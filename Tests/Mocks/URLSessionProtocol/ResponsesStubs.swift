//
//  ResponsesStubs.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 12/15/25.
//

import Foundation
import QuickHatchHTTP

public struct URLSessionMocks {
    public static func anyResponse(statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "www.google.com")!,
                               statusCode: statusCode,
                               httpVersion: "1.1",
                               headerFields: nil)!
    }
    
    public static var anyDataModelSample: Data {
        let dataModel = DataModel(name: "dan", nick: "sp", age: 12)
        if let encodedData = try? JSONEncoder().encode(dataModel) {
            return encodedData
        }
        return Data()
    }
    
    public static func anyResponse(withData: Data? = nil, withStatusCode: Int = 200) -> HTTPResponse {
        return QHHTTPResponse(body: withData, urlResponse: anyResponse(statusCode: withStatusCode))
    }

}
