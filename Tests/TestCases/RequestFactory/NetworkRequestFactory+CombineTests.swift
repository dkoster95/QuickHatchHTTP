//
//  NetworkRequestFactory+CombineTests.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 10/7/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import XCTest
import QuickHatchHTTP
@testable import QuickHatchHTTPMocks
import Combine

class QHNetworkRequestFactory_CombineTests: URLSessionNetworkRequestFactoryTestCase {
    var subscriptions: Set<AnyCancellable> = []
    
    func testResponseSerializationErrorCase() {
        let expectation = XCTestExpectation()
        let fakeUrlSession = URLSessionMock(data: self.getArrayModelSample, urlResponse: getResponse(statusCode: 200))
        let subject = sut(urlSession: fakeUrlSession)
        subject.response(urlRequest: fakeURLRequest).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error): XCTAssertEqual(RequestError.serializationError(error: MockError.mock), RequestError.map(error: error))
            case .finished: break
            }
            expectation.fulfill()
        }, receiveValue: { (data : Response<DataModel>) in
            XCTAssert(false)
            expectation.fulfill()
        }).store(in: &subscriptions)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testBadRequestError() {
        let expectation = XCTestExpectation()
        let dataURLSession = URLSessionProtocolMock(data: Data(), urlResponse: getResponse(statusCode: 400))
        let subject = sut(urlSession: dataURLSession)
        subject.response(urlRequest: fakeURLRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(RequestError.requestWithError(statusCode: .badRequest), RequestError.map(error: error))
                case .finished: break
                }
                expectation.fulfill()
            }, receiveValue: { (_ : Response<DataModel>) in
                XCTAssert(false)
                expectation.fulfill()
            }).store(in: &subscriptions)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCancelledError() {
        let expectation = XCTestExpectation()
        let dataURLSession = URLSessionProtocolMock()
        dataURLSession.urlError = URLError(.cancelled)
        let subject = sut(urlSession: dataURLSession)
        subject.response(urlRequest: fakeURLRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(RequestError.cancelled, RequestError.map(error: error))
                case .finished: break
                }
                expectation.fulfill()
            }, receiveValue: { (_ : Response<DataModel>) in
                XCTAssert(false)
                expectation.fulfill()
            }).store(in: &subscriptions)
        wait(for: [expectation], timeout: 1.0)
    }
}

enum MockError: Error {
    case mock
}
