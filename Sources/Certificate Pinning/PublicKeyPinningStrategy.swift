//
//  PublicKeyPinnerStrategy.swift
//  QuickHatch
//
//  Created by Daniel Koster on 8/4/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation

public struct PublicKeyPinningStrategy: PinningStrategy {
    private let publicKeys: [String]
    private let hasher: Hasher
    
    public init(publicKeys: [String], hasher: Hasher) {
        self.publicKeys = publicKeys
        self.hasher = hasher
    }
    
    public func validate(serverTrust: SecTrust) -> Bool {
        if let publicKey = extractKey(serverTrust: serverTrust) {
            return publicKeys.contains(publicKey)
        }
        return false
    }
    
    private func extractKey(serverTrust: SecTrust) -> String? {
        if let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
            let serverPublicKey = SecCertificateCopyKey(certificate),
            let publicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) as Data? {
            return hasher.hash(data: publicKeyData)
        }
        return nil
    }
}
