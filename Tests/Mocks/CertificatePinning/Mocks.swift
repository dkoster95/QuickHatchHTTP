//
//  Mocks.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/14/25.
//
import QuickHatchHTTP
import Foundation

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

public final class MockURLProtectionSpace: URLProtectionSpace {
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
