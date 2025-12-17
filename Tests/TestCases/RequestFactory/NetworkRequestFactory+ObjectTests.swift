//
//  URLSessionLayer+ObjectTests.swift
//  QuickHatch
//
//  Created by Daniel Koster on 10/18/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Foundation
import QuickHatchHTTP
import XCTest
@testable import QuickHatchHTTPMocks

final class URLSessionNetworkRequestFactory_ObjectTests: URLSessionNetworkRequestFactoryTestCase {
    
    func test_response_whenfailureSerializationDataUsingObject_expectCorrectError() throws {
        let fakeUrlSession = URLSessionProtocolMock(data: getArrayModelSample,
                                                    urlResponse: getResponse(statusCode: 200))
        let urlSessionLayer = sut(urlSession: fakeUrlSession)
        let url = try XCTUnwrap(URL(string: "www.google.com"))
        urlSessionLayer.response(request: try URLRequest(url: url,
                                                         method: .get)) { (result: Result<Response<DataModel>, Error>) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if let requestError = error as? RequestError {
                    XCTAssert(requestError == .serializationError(error: RequestError.unauthorized))
                } else {
                    XCTAssert(false)
                }
            }
        }.resume()
    }
    
    func test_response_whenSerializationError_expectCorrectError() throws {
        let data = try JSONSerialization.data(withJSONObject: ["name": "hey"], options: .prettyPrinted)
        let dataURLSession = URLSessionProtocolMock(data: data, urlResponse: getResponse(statusCode: 200))
        let urlSessionLayer = sut(urlSession: dataURLSession)
        let url = try XCTUnwrap(URL(string: "www.google.com"))
        
        urlSessionLayer.response(request: URLRequest(url: url)) { (result: Result<Response<DataModel>, Error>) in
            switch result {
            case .failure(let error):
                if let reqError = error as? RequestError {
                    XCTAssert(reqError == RequestError.serializationError(error: RequestError.unauthorized))
                }
            case .success:
                XCTAssert(false)
            }
        }.resume()
    }
    
    func test_response_whenSuccess_expectFullDataUsingObject() throws {
        let fakeUrlSession = URLSessionProtocolMock(data: self.getDataModelSample, urlResponse: getResponse(statusCode: 200))
        let urlSessionLayer = sut(urlSession: fakeUrlSession)
        let url = try XCTUnwrap(URL(string: "www.google.com"))
        
        urlSessionLayer.response(request: try URLRequest(url: url,
                                                     method: .get)) { (result: Result<Response<DataModel>, Error>) in
            switch result {
            case .success(let dataModel):
                XCTAssert(dataModel.data.age! == 12)
            case .failure:
                    XCTAssert(false)
            }
            }.resume()
    }
    func test_response_whenUnknownErrorUsingStringObject_expectCorrectError() throws {
        let unauthorizedUrlSession = URLSessionProtocolMock(urlResponse: getResponse(statusCode: 524))
        let urlSessionLayer = sut(urlSession: unauthorizedUrlSession)
        let url = try XCTUnwrap(URL(string: "www.google.com"))
        
        urlSessionLayer.response(request: try URLRequest(url: url,
                                                     method: .get)) { (result: Result<Response<DataModel>, Error>) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                if let requestError = error as? RequestError {
                    XCTAssert(requestError == .unknownError(statusCode: 524))
                } else {
                    XCTAssert(false)
                }
            }
            }.resume()
    }
    
    func test_response_whenCancelledError_expectCorrectError() throws {
        let dataURLSession = URLSessionProtocolMock(error: NSError(domain: "", code: -999, userInfo: nil), urlResponse: getResponse(statusCode: 200))
        let urlSessionLayer = sut(urlSession: dataURLSession)
        let url = try XCTUnwrap(URL(string: "www.google.com"))
        
        urlSessionLayer.response(request: URLRequest(url: url)) { (result: Result<Response<DataModel>, Error>) in
            switch result {
            case .failure(let error):
                if let reqError = error as? RequestError {
                    XCTAssert(reqError == RequestError.cancelled)
                }
            case .success:
                XCTAssert(false)
            }
            }.resume()
    }
    
}
