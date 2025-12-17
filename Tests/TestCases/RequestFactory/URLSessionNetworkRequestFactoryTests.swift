//
//  URLSessionLayerTests.swift
//  NetworkingLayerTests
//
//  Created by Daniel Koster on 6/5/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import XCTest
import QuickHatchHTTP
@testable import QuickHatchHTTPMocks
import Testing
import Combine

class URLSessionNetworkRequestFactoryTests {
    private var cancellable = Set<AnyCancellable>()
    
    struct AsyncDataReponseTestCase : Sendable {
        let response: URLSessionProtocolMock
        let expectedError: RequestError?
        let expectedResult: Data?
        
        init(response: URLSessionProtocolMock,
             expectedError: RequestError? = nil,
             expectedResult: Data? = nil) {
            self.response = response
            self.expectedError = expectedError
            self.expectedResult = expectedResult
        }
    }

    struct AsyncDataResponseTestCases {
        static let unauthorizedResponse = AsyncDataReponseTestCase(response:  URLSessionProtocolMock(data: Data(),
                                                                                                     error: nil,
                                                                                                     urlResponse: URLSessionMocks.anyResponse(statusCode: 401)),
                                                                   expectedError: RequestError.requestWithError(statusCode: .unauthorized))
        static let urlErrorCancelledResponse = AsyncDataReponseTestCase(response:  URLSessionProtocolMock(data: nil,
                                                                                                          error: URLError(URLError.cancelled),
                                                                                                          urlResponse: nil),
                                                                        expectedError: RequestError.cancelled)
        static let noResponse = AsyncDataReponseTestCase(response:  URLSessionProtocolMock(data: nil,
                                                                                           error: nil,
                                                                                           urlResponse: nil),
                                                         expectedError: RequestError.noResponse)
        static let correctDataResponse = AsyncDataReponseTestCase(response:  URLSessionProtocolMock(data: Data(),
                                                                                                error: nil,
                                                                                                urlResponse: URLSessionMocks.anyResponse(statusCode: 200)))
        static let correctResponse = AsyncDataReponseTestCase(response:  URLSessionProtocolMock(data: URLSessionMocks.anyDataModelSample,
                                                                                                error: nil,
                                                                                                urlResponse: URLSessionMocks.anyResponse(statusCode: 200)),
                                                              expectedResult: URLSessionMocks.anyDataModelSample)
    }
    
    @Test(arguments: [AsyncDataResponseTestCases.unauthorizedResponse,
                      AsyncDataResponseTestCases.urlErrorCancelledResponse,
                      AsyncDataResponseTestCases.correctDataResponse])
    func dataPublisher(testCase: AsyncDataReponseTestCase) async throws {
        testCase.response.data = Data()
        let sut = URLSessionRequestFactory(urlSession: testCase.response)
        
        let url = try #require(URL(string: "www.google.com"))
        let dummyRequest = try URLRequest(url: url, method: .get)
        await confirmation("") { confirmation in
            sut.dataPublisher(request: dummyRequest)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        if let requestError = error as? RequestError {
                            #expect(requestError == testCase.expectedError)
                            confirmation.confirm()
                        }
                    case .finished: break
                    }
                }, receiveValue: { response in
                    #expect(response.body != nil)
                    confirmation.confirm()
                })
            .store(in: &cancellable)
        }
    }
    
    @Test(arguments: [AsyncDataResponseTestCases.unauthorizedResponse,
                      AsyncDataResponseTestCases.urlErrorCancelledResponse,
                      AsyncDataResponseTestCases.noResponse,
                      AsyncDataResponseTestCases.correctDataResponse])
    func asyncDataResponse(testCase: AsyncDataReponseTestCase) async throws {
        let sut = URLSessionRequestFactory(urlSession: testCase.response)
        
        let url = try #require(URL(string: "www.google.com"))
        let dummyRequest = try URLRequest(url: url, method: .get)
        do {
            let response = try await sut.data(request: dummyRequest)
            #expect(response.body != nil)
        } catch let error as RequestError {
            #expect(error == testCase.expectedError)
        }
    }
    
    @Test(arguments: [AsyncDataResponseTestCases.unauthorizedResponse,
                      AsyncDataResponseTestCases.urlErrorCancelledResponse,
                      AsyncDataResponseTestCases.noResponse,
                      AsyncDataResponseTestCases.correctResponse])
    func asyncDataMappedResponse(testCase: AsyncDataReponseTestCase) async throws {
        let sut = URLSessionRequestFactory(urlSession: testCase.response)
        
        let url = try #require(URL(string: "www.google.com"))
        let dummyRequest = try URLRequest(url: url, method: .get)
        do {
            let response: Response<DataModel> = try await sut.response(request: dummyRequest)
            let expectedResult = try #require(testCase.expectedResult)
            let expectedData = try JSONDecoder().decode(DataModel.self, from: expectedResult)
            #expect(response.data.name == expectedData.name)
            
        } catch let error as RequestError {
            #expect(error == testCase.expectedError)
        }
    }
}
