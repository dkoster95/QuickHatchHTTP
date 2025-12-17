//
//  FakeDataModel.swift
//  QuickHatchTests
//
//  Created by Daniel Koster on 6/5/19.
//  Copyright © 2019 DaVinci Labs. All rights reserved.
//

import Foundation

public class DataModel: Codable, @unchecked Sendable {
    var name: String?
    var nick: String
    var age: Int?
    
    public init(name: String, nick: String, age: Int) {
        self.name = name
        self.nick = nick
        self.age = age
    }
}

public extension DataModel {
    static func getMock() throws -> DataModel {
        let path = Bundle(for: self).path(forResource: "DataMock", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
        let dataModel = try JSONDecoder().decode(DataModel.self, from: data)
        return dataModel
    }
}
