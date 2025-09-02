//
//  StringEncodingTests.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 8/14/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import XCTest
import QuickHatchHTTP
// swiftlint:disable force_try

final class StringEncodingTests: XCTestCase {

    func test_encode_whenURLValidAndParams_expectParamsEncoded() throws {
        let sut = StringEncoding()
        let escapedUrlString = EncodingHelpers.escape("www.quickhatch.com/{name}")
        let url = try XCTUnwrap(URL(string: escapedUrlString))
        let urlRequest = try URLRequest(url: url, method: .get)
        let requestResult = try sut.encode(urlRequest,
                                           with: ["name": "dani"])
        
        let result = try XCTUnwrap(requestResult.url).absoluteString
        
        XCTAssertEqual("www.quickhatch.com/dani", result)
    }
    
    func test_encode_whenURLValidAndNoParams_expectNoChange() throws {
        let sut = StringEncoding()
        let escapedUrlString = EncodingHelpers.escape("www.quickhatch.com/{name}")
        let url = try XCTUnwrap(URL(string: escapedUrlString))
        let urlRequest = try URLRequest(url: url, method: .get)
        let requestResult = try sut.encode(urlRequest,
                                           with: [:])
        
        let result = try XCTUnwrap(requestResult.url).absoluteString
        
        XCTAssertEqual(escapedUrlString, result)
    }
    
    func test_encode_whenValidURLAndManyParams_expect_parametersEncoded() throws {
        let sut = StringEncoding()
        let escapedUrlString = EncodingHelpers.escape("www.quickhatch.com/{name}/{age}")
        let url = try XCTUnwrap(URL(string: escapedUrlString))
        let urlRequest = try URLRequest(url: url, method: .get)
        let requestResult = try sut.encode(urlRequest,
                                           with: ["name": "dani","age": 13])

        let result = try XCTUnwrap(requestResult.url).absoluteString
        
        XCTAssertEqual("www.quickhatch.com/dani/13", result)
    }
    
    func testStringEncodingManyParametersAndHeaders() throws {
        let urlString = EncodingHelpers.escape("www.quickhatch.com/{name}/{age}")
        print(urlString)
        var urlRequest = try URLRequest(url: URL(string: urlString)!, method: .get)
        urlRequest.addValue("header", forHTTPHeaderField: "header")
        let stringEncoding = StringEncoding.urlEncoding
        let requestResult = try! stringEncoding.encode(urlRequest,
                                                       with: ["name": "dani","age": 13])
        XCTAssertTrue(requestResult.url!.absoluteString == "www.quickhatch.com/dani/13")
        XCTAssertTrue(requestResult.allHTTPHeaderFields!["header"] == "header")
    }
    
    func testStringEncodingError() {
        var urlRequest = URLRequest(url: URL(string: "www.quickhatch.com")!)
        urlRequest.url = nil
        let stringEncoding = StringEncoding()
        do {
            _ = try stringEncoding.encode(urlRequest,
                                                       with: ["name": "dani","age": 13])
        } catch _ {
            XCTAssertTrue(true)
        }
        
    }
    
    func testStringEncodingManyBodyParametersAndHeaders() throws {
        let urlString = EncodingHelpers.escape("www.quickhatch.com/{name}/{age}")
        print(urlString)
        var urlRequest = try URLRequest(url: URL(string: urlString)!, method: .get)
        urlRequest.addValue("header", forHTTPHeaderField: "header")
        let stringEncoding = StringEncoding.bodyEncoding
        let requestResult = try! stringEncoding.encode(urlRequest,
                                                       with: ["name": "dani","age": 13])
        let body = String(data: requestResult.httpBody!, encoding: .utf8)
        let split = body!.split(separator: "&")
        XCTAssertTrue(split.count == 2)
        XCTAssertTrue(split.contains("dani"))
        XCTAssertTrue(split.contains("13"))
        XCTAssertTrue(requestResult.allHTTPHeaderFields!["header"] == "header")
    }
    
    func testStringEncodingBodyParametersAndHeaders() throws {
        let urlString = EncodingHelpers.escape("www.quickhatch.com/{name}/{age}")
        print(urlString)
        var urlRequest = try URLRequest(url: URL(string: urlString)!, method: .get)
        urlRequest.addValue("header", forHTTPHeaderField: "header")
        let stringEncoding = StringEncoding.bodyEncoding
        let requestResult = try! stringEncoding.encode(urlRequest,
                                                       with: ["age": 13])
        let body = String(data: requestResult.httpBody!, encoding: .utf8)
        let split = body!.split(separator: "&")
        XCTAssertTrue(split.count == 1)
        XCTAssertTrue(split.contains("13"))
        XCTAssertTrue(requestResult.allHTTPHeaderFields!["header"] == "header")
    }
    
    func testStringEncodingBodyNoParametersAndHeaders() throws {
        let urlString = EncodingHelpers.escape("www.quickhatch.com/{name}/{age}")
        print(urlString)
        var urlRequest = try URLRequest(url: URL(string: urlString)!, method: .get)
        urlRequest.addValue("header", forHTTPHeaderField: "header")
        let stringEncoding = StringEncoding.bodyEncoding
        let requestResult = try! stringEncoding.encode(urlRequest,
                                                       with: [:])
        XCTAssertNil(requestResult.httpBody)
        XCTAssertTrue(requestResult.allHTTPHeaderFields!["header"] == "header")
    }

}
