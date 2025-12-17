//
//  URLSessionDataTasksTests.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 8/15/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Testing
import QuickHatchHTTP
import Foundation

struct URLSessionDataTasksTests {

    @Test(arguments: [(RequestError.cancelled, false), (RequestError.unauthorized, true)])
    func testUnauthorizedError(requestError: RequestError, expectedResult: Bool) {
        #expect(requestError.isUnauthorized == expectedResult)
    }
    
    @Test(arguments: [(-999, true),
                      (-99, false)])
    func testRequestWasCancelled(errorCode: Int, expectedReslt: Bool) {
        let error = NSError(domain: "", code: errorCode, userInfo: nil)
        #expect(error.requestWasCancelled == expectedReslt)
    }
    
    @Test func testHTTPStatusCode() {
        let httpStatus = 200
        #expect(HTTPStatusCode(rawValue: httpStatus) != nil)
    }
    
    @Test func testHTTPStatusCodeIsSuccess() {
        let httpStatus = 200
        let status = HTTPStatusCode(rawValue: httpStatus)!
        #expect(status.isSuccess)
    }
    
    @Test func testHTTPStatusCodeIsInfo() {
        let httpStatus = 100
        let status = HTTPStatusCode(rawValue: httpStatus)!
        #expect(status.isInformational)
    }
    
    @Test func testHTTPStatusCodeIsClientError() {
        let httpStatus = 404
        let status = HTTPStatusCode(rawValue: httpStatus)!
        #expect(status.isClientError)
    }
    
    @Test func testHTTPStatusCodeIsServer() {
        let httpStatus = 500
        let status = HTTPStatusCode(rawValue: httpStatus)!
        #expect(status.isServerError)
        #expect(status.description == "500 - internal server error")
        #expect(status.debugDescription == "HTTPStatusCode:500 - internal server error")
    }
    
    @Test func testHTTPStatusCodeIsRedirection() {
        let httpStatus = 300
        let status = HTTPStatusCode(rawValue: httpStatus)!
        #expect(status.isRedirection)
    }

}
