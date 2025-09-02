//
//  EncodingHelpersTests.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 8/14/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Testing
import QuickHatchHTTP

struct EncodingHelpersTests {
    
    @Test(arguments: [("boolValue", true), ("boolValue", false)])
    func queryComponents_whenBool(key: String, boolValue: Bool) {
        let result = EncodingHelpers.queryComponents(fromKey: key, value: boolValue)
        print(result)
        #expect(result[0].0 == "boolValue")
        #expect(result[0].1 == boolValue.intValue.description)
    }
    
    @Test
    func queryComponentsWithInt() {
        let int = 2
        let result = EncodingHelpers.queryComponents(fromKey: "intValue", value: int)
        #expect(result[0].0 == "intValue")
        #expect(result[0].1 == "2")
    }
    
    @Test
    func queryComponentsWithString() {
        let string = "quickhatch"
        let result = EncodingHelpers.queryComponents(fromKey: "stringValue", value: string)
        #expect(result[0].0 == "stringValue")
        #expect(result[0].1 == "quickhatch")
    }
    
    @Test
    func queryComponentsWithArray() {
        let string = "quickhatch"
        let int = 2
        let array = [string,int] as [Any]
        let result = EncodingHelpers.queryComponents(fromKey: "arrayValue", value: array)
        #expect(result[0].0 == "arrayValue")
        #expect(result[0].1 == "quickhatch")
        #expect(result[1].0 == "arrayValue")
        #expect(result[1].1 == "2")
    }
    
    @Test
    func queryComponentsWithDic() {
        let string = "quickhatch"
        let int = 2
        let dic = ["string": string,"int": int] as [String: Any]
        
        let result = EncodingHelpers.queryComponents(fromKey: "dicValue", value: dic)
        
        let containsString = !result.filter({
            return $0 == EncodingHelpers.escape("dicValue[string]") && $1 == "quickhatch"
        }).isEmpty
        let containsInt = !result.filter({
            return $0 == EncodingHelpers.escape("dicValue[int]") && $1 == "2"
        }).isEmpty
        #expect(containsString && containsInt)
    }
    
    @Test
    func escapedString() {
        let expected = "%5Bint%5D"
        #expect(EncodingHelpers.escape("[int]") == expected)
    }
    
    @Test(arguments: [(false, "false"), (true, "true")])
    func boolStringValue(value: Bool, expectedResult: String) {
        #expect(value.stringValue == expectedResult)
    }
    
    @Test(arguments: [(false, 0), (true, 1)])
    func testBoolIntValue(value: Bool, expectedResult: Int) {
        #expect(value.intValue == expectedResult)
    }
}
