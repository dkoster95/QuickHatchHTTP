//
//  URLSessionPinningDelegate.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 8/14/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//
import Foundation
import QuickHatchHTTP
import QuickHatchHTTPMocks
import Testing

struct URLSessionPinningDelegateTests {
    
    struct TestMetadata {
        let challenge: URLAuthenticationChallenge
        let certificatePinnerIsServerTrustedResult: Bool
        let credentialResult: URLCredential?
        let result: URLSession.AuthChallengeDisposition
    }
    
    private struct TestCases {
        static let whenChallengeIsNilExpectInvalid = TestMetadata(challenge: Stubs.CertificatePinner.fakeChallenge(with: nil),
                                                                         certificatePinnerIsServerTrustedResult: false,
                                                                         credentialResult: nil,
                                                                         result: .cancelAuthenticationChallenge)
        static let whenChallengeIsValidAndServerIsNotTrustedExpectInvalid = TestMetadata(challenge: Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.certificate),
                                                                                                certificatePinnerIsServerTrustedResult: false,
                                                                                                credentialResult: nil,
                                                                                                result: .cancelAuthenticationChallenge)
        static let whenChallengeIsValidAndServerIsTrustedExpectValid = TestMetadata(challenge: Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.certificate),
                                                                                           certificatePinnerIsServerTrustedResult: true,
                                                                                           credentialResult: URLCredential(trust: Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.certificate).protectionSpace.serverTrust!),
                                                                                           result: .useCredential)
    }
    
    @Test(arguments: [TestCases.whenChallengeIsNilExpectInvalid,
                      TestCases.whenChallengeIsValidAndServerIsNotTrustedExpectInvalid,
                      TestCases.whenChallengeIsValidAndServerIsTrustedExpectValid])
    func urlSessionTests(metadata: TestMetadata) async {
        await confirmation("") { confirmation in
            let (sut, mock) = sut()
            mock.isServerTrustedResult = metadata.certificatePinnerIsServerTrustedResult
            sut.urlSession(didReceive: metadata.challenge) { result, credential in
                if metadata.credentialResult != nil {
                    #expect(credential != nil)
                } else {
                    #expect(credential == metadata.credentialResult)
                }
                #expect(result == metadata.result)
                confirmation.confirm()
            }
        }
    }
    
    private func sut() -> (URLSessionPinningDelegateAdapter, CertificatePinnerMock) {
        let mock = CertificatePinnerMock()
        let sut = URLSessionPinningDelegateAdapter(certificatePinner: mock)
        return (sut, mock)
    }

}
