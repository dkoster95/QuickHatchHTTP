//
//  CertificatePinnerTestsHelpers.swift
//  QuickHatch
//
//  Created by Daniel Koster on 8/13/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import QuickHatchHTTP
import Foundation
import QuickHatchHTTPMocks

struct Stubs {
    struct CertificatePinner {
        static func fakeChallenge(with certificate: SecCertificate?) -> URLAuthenticationChallenge {
            var serverTrust: SecTrust?
            SecTrustCreateWithCertificates([certificate] as CFArray, SecPolicyCreateBasicX509(), &serverTrust)
            let space = MockURLProtectionSpace(serverTrust: serverTrust, host: "nobody", port: 8080)
            return URLAuthenticationChallenge(protectionSpace: space,
                                              proposedCredential: nil,
                                              previousFailureCount: 0,
                                              failureResponse: nil,
                                              error: nil,
                                              sender: MockAuthenticationChallengeSender())
        }
        
        static func fakeChallenge(with certificate: SecCertificate?,
                                  host: String,
                                  authType: String = NSURLAuthenticationMethodServerTrust) -> URLAuthenticationChallenge {
            var serverTrust: SecTrust?
            SecTrustCreateWithCertificates([certificate] as CFArray, SecPolicyCreateBasicX509(), &serverTrust)
            let space = MockURLProtectionSpace(serverTrust: serverTrust, host: host, port: 8080, authenticationMethod: authType)
            return URLAuthenticationChallenge(protectionSpace: space,
                                              proposedCredential: nil,
                                              previousFailureCount: 0,
                                              failureResponse: nil,
                                              error: nil,
                                              sender: MockAuthenticationChallengeSender())
        }
        static let bundle = Bundle.module
        static var certificate: SecCertificate? {
            let reader = QHCertificateReader(logger: Log(LogsShortcuts.certificatePinner))
            return try? reader.open(name: "certificate", type: "der", bundle: bundle) ?? nil
        }
        
        static var davinciCertificate: SecCertificate? {
            let reader = QHCertificateReader(logger: Log(LogsShortcuts.certificatePinner))
            return try? reader.open(name: "davinci.com", type: "der", bundle: bundle) ?? nil
        }
    }
}
