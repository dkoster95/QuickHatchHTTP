//
//  PinningStrategy.swift
//  QuickHatch
//
//  Created by Daniel Koster on 8/4/20.
//  Copyright © 2020 DaVinci Labs. All rights reserved.
//

import Foundation

public protocol PinningStrategy: Sendable {
    func validate(serverTrust: SecTrust) -> Bool
}
