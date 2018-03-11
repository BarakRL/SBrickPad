//
//  GameControllerValueActions.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/21/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import SBrick

protocol GameControllerValueAction: GameControllerAction {
}

//MARK: - Actions -

class DriveValueAction: GameControllerValueAction {
    
    var port: SBrickPort
    var minPower: UInt8
    var maxPower: UInt8
    var isCW: Bool
    var easing: GameControllerValueActionEasing
    
    var type: String = DriveValueAction.type
    var name: String { return "Drive Value" }
    var info: String { return "Port: \(self.port), Power: \(self.minPower)-\(self.maxPower) \(self.isCW ? "CW" : "CCW")" }
    
    init(port: SBrickPort, minPower: UInt8, maxPower: UInt8, isCW: Bool, easing: GameControllerValueActionEasing = .linear) {
        self.port = port
        self.minPower = minPower
        self.maxPower = maxPower
        self.isCW = isCW
        self.easing = easing
    }
    
    func relativePower(fromValue inValue: Float) -> (value: UInt8, isNegative: Bool) {
        return self.relativeValue(fromValue: inValue, minOutValue: minPower, maxOutValue: maxPower, easing: easing)
    }
}

//MARK: - Helpers

extension GameControllerValueAction {
    
    func relativeValue(fromValue inValue: Float, minOutValue: UInt8, maxOutValue: UInt8, easing: GameControllerValueActionEasing) -> (value: UInt8, isNegative: Bool) {
        
        //keep polarity, but calculate as UInt8
        let isNegative: Bool = (inValue < 0)
        let value = easing.curve(abs(inValue))
        
        //print("\(inValue) -> \(isNegative ? "-" : "+")\(value))")
        
        //protect (if min = 100, max = 50 -> min = 50)
        let minOutValue = min(maxOutValue, minOutValue)
        
        //normalize
        let relativeValue = UInt(Float(maxOutValue - minOutValue) * value) + UInt(minOutValue)
        
        //protect and cast
        let outValue = UInt8(min(relativeValue, UInt(0xFF)))
        return (value: outValue, isNegative: isNegative)
    }
}
