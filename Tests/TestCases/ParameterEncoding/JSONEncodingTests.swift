//
//  JSONEncodingTests.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/29/25.
//
import Foundation
import QuickHatchHTTP
import Testing

struct JSONEncodingTests {
    
    @Test
    func jsonEncoding() throws {
        let sut = JSONEncoding.default
        let urlRequest = URLRequest(url: try #require(URL(string: "quickhatch.com")))
        
        let result = try sut.encode(urlRequest, with: ["user_id": "ABCD12345", "age": 20])
        let body = try #require(result.httpBody)
        let decoded = try #require(try JSONSerialization.jsonObject(with: body) as? [String: any Sendable])
        
        #expect(NSDictionary(dictionary: decoded) == ["user_id": "ABCD12345", "age": 20])
    }
}
