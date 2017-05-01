//
//  GameControllerAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 4/30/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation

enum GameControllerPressAction {
    
    case playSound(soundName: String, ext: String)
    case stopSound(soundName: String, ext: String)
    case drive(channel: UInt8, cw: Bool, power: UInt8)
    case stop(channel: UInt8)    
}

enum GameControllerValueAction {
    
    case drive(channel: UInt8, cw: Bool, minPower: UInt8, maxPower: UInt8)
        
    //MARK: - Helpers
    static func power(fromValue value: Float, minPower: UInt8, maxPower: UInt8) -> UInt8 {
        
        //protect (if min = 100, max = 50 -> min = 50)
        let minPower = min(maxPower, minPower)
        
        //normalize
        let relativePower = UInt(Float(maxPower - minPower) * value) + UInt(minPower)
        
        //protect and cast
        return UInt8(min(relativePower, UInt(0xFF)))
    }
    
}
