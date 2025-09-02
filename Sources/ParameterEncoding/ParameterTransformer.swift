//
//  ParameterTransformer.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/29/25.
//
import Foundation

public protocol ParameterTransformer {
    func transform(parameters: [String: any Sendable]) -> String
}

public struct DefaultParameterTransformer: ParameterTransformer {
    
    public init() {
        
    }
    
    public func transform(parameters: [String : any Sendable]) -> String {
        let parameters = parameters
            .flatMap { (key, value) in EncodingHelpers.queryComponents(fromKey: key, value: value) }
            .map { "\($0)=\($1)" }
            .sorted(by: >)
        return parameters.joined(separator: "&")
    }
}
