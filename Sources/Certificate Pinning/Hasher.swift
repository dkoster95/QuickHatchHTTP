//
//  Hasher.swift
//  QuickHatch
//
//  Created by Daniel Koster on 8/11/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation
import CryptoKit

public protocol Hasher: Sendable {
    func hash(data: Data) -> String
}

public final class CKSHA256Hasher: Hasher {
    
    public init() {
        
    }
    
    public func hash(data: Data) -> String {
        return SHA256.hash(data: data).data.base64EncodedString()
    }
}

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
}
