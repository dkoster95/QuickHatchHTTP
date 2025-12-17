//
//  HTTPRequestTests.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/13/25.
//
import QuickHatchHTTP
import Foundation
import Testing

struct HTTPRequestTests {
    
    @Test
    func asURLRequest_expectHeadersCorrectlyParsed() throws {
        let sut = QHHTTPRequest(headers: ["Content-Type": "json"],
                                url: "quickhatch.com",
                                method: .get)
        
        let result = try sut.asURLRequest()
        
        let headers = try #require(result.allHTTPHeaderFields)
        let url = try #require(result.url?.absoluteString)
        let method = try #require(result.httpMethod)
        
        #expect(url == "quickhatch.com")
        #expect(headers == ["Content-Type": "json"])
        #expect(method == "GET")
    }
}
