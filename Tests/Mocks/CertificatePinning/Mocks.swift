//
//  Mocks.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/14/25.
//
import QuickHatchHTTP
import Foundation
import Combine

public class PinningStrategyMock: PinningStrategy {
    
    public var invokedValidate = false
    public var invokedValidateCount = 0
    public var invokedValidateParameters: (serverTrust: SecTrust, Void)?
    public var invokedValidateParametersList = [(serverTrust: SecTrust, Void)]()
    public var stubbedValidateResult: Bool! = false
    
    public init() {
        
    }
    
    public func validate(serverTrust: SecTrust) -> Bool {
        invokedValidate = true
        invokedValidateCount += 1
        invokedValidateParameters = (serverTrust, ())
        invokedValidateParametersList.append((serverTrust, ()))
        return stubbedValidateResult
    }
}

public class CertificatePinnerMock: CertificatePinner {

    public init() {
        
    }
    
    public var isServerTrustedResult = true
    public func isServerTrusted(challenge: URLAuthenticationChallenge) -> Bool {
        return isServerTrustedResult
    }
}

public final class MockAuthenticationChallengeSender: NSObject, URLAuthenticationChallengeSender {
    public func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        
    }
    
    public func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        
    }
    
    public func cancel(_ challenge: URLAuthenticationChallenge) {
        
    }
    
}

public final class MockURLProtectionSpace: URLProtectionSpace, @unchecked Sendable {
    private let trust: SecTrust?
    public init(serverTrust: SecTrust?,host: String, port: Int, authenticationMethod: String? = nil) {
        self.trust = serverTrust
        super.init(host: host, port: port, protocol: nil, realm: nil, authenticationMethod: authenticationMethod)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var serverTrust: SecTrust? {
        return trust
    }
}

public final class NetworkRequestFactoryMock: NetworkRequestFactory {

    public var invokedDataRequest = false
    public var invokedDataRequestCount = 0
    public var invokedDataRequestParameters: (request: URLRequest, dispatchQueue: DispatchQueue)?
    public var invokedDataRequestParametersList = [(request: URLRequest, dispatchQueue: DispatchQueue)]()
    public var stubbedDataRequestCompletionResult: (Result<HTTPResponse, Error>, Void)?
    public var stubbedDataRequestResult: DataTask!

    public func data(request: URLRequest,
        dispatchQueue: DispatchQueue,
        completionHandler completion: @Sendable @escaping (Result<HTTPResponse, Error>) -> Void) -> DataTask {
        invokedDataRequest = true
        invokedDataRequestCount += 1
        invokedDataRequestParameters = (request, dispatchQueue)
        invokedDataRequestParametersList.append((request, dispatchQueue))
        if let result = stubbedDataRequestCompletionResult {
            completion(result.0)
        }
        return stubbedDataRequestResult
    }

    public var invokedDataPublisher = false
    public var invokedDataPublisherCount = 0
    public var invokedDataPublisherParameters: (request: URLRequest, Void)?
    public var invokedDataPublisherParametersList = [(request: URLRequest, Void)]()
    public var subject = PassthroughSubject<HTTPResponse, Error>()

    public func dataPublisher(request: URLRequest) -> AnyPublisher<HTTPResponse,Error> {
        invokedDataPublisher = true
        invokedDataPublisherCount += 1
        invokedDataPublisherParameters = (request, ())
        invokedDataPublisherParametersList.append((request, ()))
        return subject.eraseToAnyPublisher()
    }

    public var invokedAsyncData = false
    public var invokedAsyncDataCount = 0
    public var invokedAsyncDataParameters: (request: URLRequest, Void)?
    public var invokedAsyncDataParametersList = [(request: URLRequest, Void)]()
    public var asyncDataResponseResult: HTTPResponse!
    public var asyncDataErrorThrown: Error?

    public func data(request: URLRequest) async throws -> HTTPResponse {
        invokedAsyncData = true
        invokedAsyncDataCount += 1
        invokedAsyncDataParameters = (request, ())
        invokedAsyncDataParametersList.append((request, ()))
        if let asyncDataErrorThrown = asyncDataErrorThrown {
            throw asyncDataErrorThrown
        }
        return asyncDataResponseResult
    }
}
