//
//  URLEncodingTests.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/29/25.
//
import Testing
import QuickHatchHTTP
import Foundation

struct URLEncodingTests {
    
    @Test
    func urlEncoding_queryEncoding() throws {
        let sut = URLEncoding.queryString
        let urlRequest = URLRequest(url: try #require(URL(string: "quickhatch.com")))
        
        let result = try sut.encode(urlRequest, with: ["user_id": "ABCD1234"])
        
        #expect(result.url?.absoluteString == "quickhatch.com?user_id=ABCD1234")
    }
    
    @Test
    func urlEncoding_bodyEncoding() throws {
        let sut = URLEncoding.httpBody
        let urlRequest = URLRequest(url: try #require(URL(string: "quickhatch.com")))
        
        let result = try sut.encode(urlRequest, with: ["user_id": "ABCD1234"])
        let body = String(decoding: try #require(result.httpBody), as: UTF8.self)
        #expect(body == "user_id=ABCD1234")
    }
}
