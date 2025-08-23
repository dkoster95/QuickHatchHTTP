//
//  CertificatePinnerStrategy.swift
//  QuickHatch
//
//  Created by Daniel Koster on 8/4/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation

public struct CertificatePinningStrategy: PinningStrategy {
    private let certificateBuilders: [() -> SecCertificate]
    
    public init(certificateBuilders: [() -> SecCertificate]) {
        self.certificateBuilders = certificateBuilders
    }
    
    public func validate(serverTrust: SecTrust) -> Bool {
        if let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
            for builder in certificateBuilders {
                if builder().toData == certificate.toData {
                    return true
                }
            }
        }
        return false
    }
}

extension SecCertificate {
    var toData: Data {
        return SecCertificateCopyData(self) as Data
    }
}
