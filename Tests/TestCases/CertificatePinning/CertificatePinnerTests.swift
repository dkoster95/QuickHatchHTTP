//
//  CertificatePinnerTests.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 8/13/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//
import Foundation
import QuickHatchHTTP
import QuickHatchHTTPMocks
import Testing

struct QHCertificatePinnerTests {
    typealias CertificatePinnerTestParam = (fakeChallenge: URLAuthenticationChallenge,
                                            pinnerValidationStub: Bool?,
                                            validateInvokedCount: Int,
                                            testResult: Bool)
    private struct TestParams {

        static let authMethodNil: CertificatePinnerTestParam = (Stubs.CertificatePinner.fakeChallenge(with: nil), nil, 0, false)
        static let certificateNil: CertificatePinnerTestParam = (Stubs.CertificatePinner.fakeChallenge(with: nil, host: ""), nil, 0, false)
        static let noHostCertificateReturned: CertificatePinnerTestParam = (Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.certificate,
                                                                                                                  host: "nohost"), nil, 0, false)
        static let invalidCertificate: CertificatePinnerTestParam = (Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.davinciCertificate,
                                                                                                           host: "quickhatch.com"), false, 1, false)
        static let validCertificate: CertificatePinnerTestParam = (Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.davinciCertificate,
                                                                                                         host: "quickhatch.com"), true, 1, true)
    }
    
    @Test(arguments: [TestParams.authMethodNil,
                      TestParams.certificateNil,
                      TestParams.noHostCertificateReturned,
                      TestParams.validCertificate])
    func isServerTrusted_whenParams_expectResults(params: CertificatePinnerTestParam) {
        let (sut, pinner) = sut()
        if let pinnerValidationStub = params.pinnerValidationStub {
            pinner.stubbedValidateResult = pinnerValidationStub
        }
        
        let result = sut.isServerTrusted(challenge: params.fakeChallenge)
        
        #expect(result == params.testResult)
        #expect(pinner.invokedValidateCount == params.validateInvokedCount)
    }
        
    private func sut() -> (QHCertificatePinner, PinningStrategyMock) {
        let pinner = PinningStrategyMock()
        let sut = QHCertificatePinner(pinningStrategies: ["quickhatch.com": [pinner]])
        return (sut, pinner)
    }
}
