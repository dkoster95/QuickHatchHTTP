//
//  URLTransformerTests.swift
//  QuickHatchHTTP
//
//  Created by Daniel Koster on 8/29/25.
//

import Testing
import QuickHatchHTTP
import Foundation

struct URLTransformerTests {
    
    struct URLTransformerTestMetadata : Sendable {
        let url: String
        let parameters: [String: any Sendable]
        let urlResult: String
    }
    
    private class DefaultURLTransformerTestCases {
        static let whenEmptyURLExpectSameURL = URLTransformerTestMetadata(url: "",
                                                                          parameters: [:],
                                                                          urlResult: "")
        static let whenNoParametersExpectSameURL = URLTransformerTestMetadata(url: "https://quickhatch.com",
                                                                              parameters: [:],
                                                                              urlResult: "https://quickhatch.com")
        static let whenParametersExpectURLTransformed = URLTransformerTestMetadata(url: "https://quickhatch.com",
                                                                                   parameters: ["id": 12, "OtherId": "ABCDE12345"],
                                                                                   urlResult: "https://quickhatch.com?id=12&OtherId=ABCDE12345")
    }
    
    private class ParameterMappingURLTransformerTestCases {
        static let whenEmptyURLExpectSameURL = URLTransformerTestMetadata(url: "",
                                                                          parameters: [:],
                                                                          urlResult: "")
        static let whenNoParametersExpectSameURL = URLTransformerTestMetadata(url: "https://quickhatch.com",
                                                                              parameters: [:],
                                                                              urlResult: "https://quickhatch.com")
        static let whenParametersExpectURLTransformed = URLTransformerTestMetadata(url: "https://quickhatch.com/{name}/{age}",
                                                                                   parameters: ["name": "quickhatch", "age": 20],
                                                                                   urlResult: EncodingHelpers.escape("https://quickhatch.com/quickhatch/20"))
    }
    
    @Test(arguments: [DefaultURLTransformerTestCases.whenEmptyURLExpectSameURL,
                      DefaultURLTransformerTestCases.whenNoParametersExpectSameURL,
                      DefaultURLTransformerTestCases.whenParametersExpectURLTransformed])
    func defaultURLTransformer_transform(metadata: URLTransformerTestMetadata) {
        let sut = DefaultURLTransformer(parameterTransformer: DefaultParameterTransformer())
        
        let result = sut.transform(url: metadata.url, parameters: metadata.parameters)
        
        #expect(result == metadata.urlResult)
    }
    
    @Test(arguments: [ParameterMappingURLTransformerTestCases.whenEmptyURLExpectSameURL,
                      ParameterMappingURLTransformerTestCases.whenParametersExpectURLTransformed,
                      ParameterMappingURLTransformerTestCases.whenNoParametersExpectSameURL])
    func parameterMappingURLTransformer_transform(metadata: URLTransformerTestMetadata) {
        let sut = ParameterMappingURLTransformer()
        
        let result = sut.transform(url: metadata.url, parameters: metadata.parameters)
        
        #expect(result == metadata.urlResult)
    }
}
