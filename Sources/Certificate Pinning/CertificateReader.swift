//
//  CertificateBuilder.swift
//  QuickHatch
//
//  Created by Daniel Koster on 8/4/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation

public protocol CertificateReader {
    func open(name: String, type: String, bundle: Bundle) throws -> SecCertificate?
    func openContent(name: String, type: String, bundle: Bundle) throws -> Data?
}

public enum CertificateError: Error, Equatable {
    case pathNotFound
    case readingError(error: String? = nil)
}

public struct QHCertificateReader: CertificateReader {
    
    private let logger: Logger
    
    public init(logger: Logger) {
        self.logger = logger
    }
    
    public func open(name: String, type: String, bundle: Bundle) throws -> SecCertificate? {
        guard let url = bundle.url(forResource: name, withExtension: type) else { throw CertificateError.pathNotFound }
        guard let fileContent = try? Data(contentsOf: url) else { throw CertificateError.readingError(error: "URL could not be read") }
        return SecCertificateCreateWithData(nil, fileContent as CFData)
    }
    
    public func openContent(name: String, type: String, bundle: Bundle) throws -> Data? {
        guard let path = bundle.path(forResource: name, ofType: type) else { throw CertificateError.pathNotFound }
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch let error {
            logger.error("Error while reading certificate: \(error)")
            throw CertificateError.readingError(error: "URL could not be read")
        }
    }
}
