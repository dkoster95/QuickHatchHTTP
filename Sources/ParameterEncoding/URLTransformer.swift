//
//  URLTransformer.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/29/25.
//
import Foundation

public protocol URLTransformer {
    func transform(url: String, parameters: [String: any Sendable]) -> String
}

public struct DefaultURLTransformer: URLTransformer {
    private let parameterTransformer: ParameterTransformer
    
    public init(parameterTransformer: ParameterTransformer) {
        self.parameterTransformer = parameterTransformer
    }
    
    public func transform(url: String, parameters: [String : any Sendable]) -> String {
        if url.isEmpty { return "" }
        let params = parameterTransformer.transform(parameters: parameters)
        return params.isEmpty ? url : url + "?" + params
    }
}

/// MARK: Use this transformer for parameter mapping
///  Example:  Input -> https://quickhatch.com/{user_id}|/{age}
///
///  Example: ParameterMappingURLTransformer().transform("https://quickhatch.com/{user_id}|/{age}", ["user_id": "ABCD1234", "age": 20])
///
///  Example: Output -> https://quickhatch.com/ABCD1234/20
///
public struct ParameterMappingURLTransformer: URLTransformer {
    
    public init() {}
    
    public func transform(url: String, parameters: [String : any Sendable]) -> String {
        guard !url.isEmpty else { return url }
        let parameters = parameters.flatMap { (key, value) in EncodingHelpers.queryComponents(fromKey: key, value: value) }
        guard !parameters.isEmpty else { return url }
        var urlResult = EncodingHelpers.escape(url)
        for (key, value) in parameters {
            let escapedKey = EncodingHelpers.escape("{\(key)}")
            urlResult = urlResult.replacingOccurrences(of: escapedKey, with: value)
        }
        return urlResult
    }
}
