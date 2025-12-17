//
//  HTTPRequestTests.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 10/13/25.
//
import QuickHatchHTTP
@testable import QuickHatchHTTPMocks
import Foundation
import Testing
import Combine

final class HTTPRequestTests {
    private var cancellables = Set<AnyCancellable>()
    
    @Test
    func asURLRequest_expectHeadersCorrectlyParsed() throws {
        let sut = QHHTTPRequest<DataModel>(headers: ["Content-Type": "json"],
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
    
    @Test
    func response_whenNoErrorSpecified_expectCorrectResponse() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        requestFactoryMock.asyncDataResponseResult = URLSessionMocks.anyResponse()
        
        do {
            _ = try await sut.response()
            #expect(requestFactoryMock.invokedAsyncDataCount == 1)
        }
        catch _ {
            #expect(Bool(false))
        }
    }
    
    @Test func response_whenErrorThrown_expectCatchToWork() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        requestFactoryMock.asyncDataResponseResult = URLSessionMocks.anyResponse()
        requestFactoryMock.asyncDataErrorThrown = RequestError.requestWithError(statusCode: HTTPStatusCode.badRequest)
        
        do {
            _ = try await sut.response()
        }
        catch let error as RequestError {
            #expect(error == .requestWithError(statusCode: .badRequest))
            #expect(requestFactoryMock.invokedAsyncDataCount == 1)
        }
    }
    
    @Test
    func responseDecoded_whenNoErrorSpecified_expectCorrectResponse() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        requestFactoryMock.asyncDataResponseResult = URLSessionMocks.anyResponse(withData: URLSessionMocks.anyDataModelSample)
        
        do {
            let response = try await sut.responseDecoded()
            let dataExpected = DataModel(name: "dan", nick: "sp", age: 12)
            #expect(requestFactoryMock.invokedAsyncDataCount == 1)
            #expect(dataExpected.name == response.data.name)
        }
        catch _ {
            #expect(Bool(false))
        }
    }
    
    @Test func responseDecoded_whenErrorThrown_expectCatchToWork() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        requestFactoryMock.asyncDataResponseResult = URLSessionMocks.anyResponse()
        requestFactoryMock.asyncDataErrorThrown = RequestError.requestWithError(statusCode: HTTPStatusCode.badRequest)
        
        do {
            _ = try await sut.responseDecoded()
        }
        catch let error as RequestError {
            #expect(error == .requestWithError(statusCode: .badRequest))
            #expect(requestFactoryMock.invokedAsyncDataCount == 1)
        }
    }
    
    @Test func responseDecodedPublisher_whenErrorThrown_expectCatchToWork() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        requestFactoryMock.subject.send(completion: Subscribers.Completion.failure(RequestError.requestWithError(statusCode: HTTPStatusCode.badRequest)))
        
        await confirmation("") { confirmation in
            sut.responseDecodedPublisher.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error as RequestError):
                    #expect(error == .requestWithError(statusCode: HTTPStatusCode.badRequest))
                    confirmation.confirm()
                case .failure(_): break
                case .finished: break
                }
            },
                                              receiveValue: { dataModel in }).store(in: &cancellables)
        }
    }
    
    @Test func responseDecodedPublisher_whenNoErrorThrown_expectCorrectResponse() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        let response = DataModel(name: "dan", nick: "sp", age: 12)
        
        await confirmation("") { confirmation in
            sut.responseDecodedPublisher.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_): break
                case .finished: break
                }
            },
                                              receiveValue: { dataModel in
                #expect(dataModel.name == response.name)
                confirmation.confirm()
            }).store(in: &cancellables)
            requestFactoryMock.subject.send(URLSessionMocks.anyResponse(withData: URLSessionMocks.anyDataModelSample))
        }
    }
    
    @Test func responsePublisher_whenErrorThrown_expectCatchToWork() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        requestFactoryMock.subject.send(completion: Subscribers.Completion.failure(RequestError.requestWithError(statusCode: HTTPStatusCode.badRequest)))
        
        await confirmation("") { confirmation in
            sut.responsePublisher.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error as RequestError):
                    #expect(error == .requestWithError(statusCode: HTTPStatusCode.badRequest))
                    confirmation.confirm()
                case .failure(_): break
                case .finished: break
                }
            },
                                              receiveValue: { _ in }).store(in: &cancellables)
        }
    }
    
    @Test func responsePublisher_whenNoErrorThrown_expectCorrectResponse() async throws {
        let requestFactoryMock = NetworkRequestFactoryMock()
        let sut = QHHTTPRequest<DataModel>(url: "quickhatch.com", method: .get, requestFactory: requestFactoryMock)
        
        await confirmation("") { confirmation in
            sut.responsePublisher.sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_): break
                case .finished: break
                }
            },
                                              receiveValue: { response in
                #expect(response.body != nil)
                confirmation.confirm()
            }).store(in: &cancellables)
            requestFactoryMock.subject.send(URLSessionMocks.anyResponse(withData: URLSessionMocks.anyDataModelSample))
        }
    }
    
}
