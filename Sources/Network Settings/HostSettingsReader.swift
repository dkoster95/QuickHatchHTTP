//
//  HostSettingsReader.swift
//  QuickHatch
//
//  Created by Daniel Koster on 5/14/21.
//  Copyright © 2021 DaVinci Labs. All rights reserved.
//

import Foundation

//public protocol HostSettingsReader {
//    func read<Settings: Codable>() -> Settings
//}
//
//private class HostConfigReader {
//    class var values: HostSettings {
//        let data = try! PropertyListSerialization.data(fromPropertyList: Bundle.init(for: Host.self).infoDictionary!,
//                                                       format: PropertyListSerialization.PropertyListFormat.binary,
//                                                       options: 0)
//        let plistDecoder = PropertyListDecoder()
//        return try! plistDecoder.decode(HostSettings.self, from: data)
//        
//    }
//}

//private struct HostSettings: Decodable {
//    let apiKey: String
//    let host: String
//    let baseUrl: String
//
//    enum CodingKeys: String, CodingKey {
//        case apiKey = "Api Key"
//        case host = "Host"
//        case baseUrl = "Base URL"
//    }
//}
