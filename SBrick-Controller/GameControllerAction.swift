//
//  GameControllerAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 4/30/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation

protocol GameControllerAction {
    
    var name: String { get }
    var description: String { get }
    
}

enum GameControllerPressAction: GameControllerAction {
    
    case playSound(soundName: String, ext: String)
    case stopSound(soundName: String, ext: String)
    case drive(channel: UInt8, cw: Bool, power: UInt8)
    case stop(channel: UInt8)    
    
    var name: String {
        
        switch self {
        case .playSound(_,_):
            return "Play Sound"

        case .stopSound(_,_):
            return "Stop Sound"
            
        case .drive(_,_,_):
            return "Drive"
            
        case .stop(_):
            return "Stop"
            
        }
        
    }
    
    var description: String {
        
        switch self {
        case .playSound(let soundName, let ext):
            return "\(soundName).\(ext)"
            
        case .stopSound(let soundName, let ext):
            return "\(soundName).\(ext)"
            
        case .drive(let channel, let cw, let power):
            return "Channel: \(channel), Power: \(power) \(cw ? "CW" : "CCW")"
            
        case .stop(let channel):
            return "Channel: \(channel)"
            
        }
    }
}

enum GameControllerValueAction: GameControllerAction {
    
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
    
    var name: String {
        
        switch self {
            
        case .drive(_,_,_,_):
            return "Drive"
            
        }
        
    }
    
    var description: String {
        
        switch self {
            
        case .drive(let channel, let cw, let minPower, let maxPower):
            return "Channel: \(channel), Power: \(minPower)-\(maxPower) \(cw ? "CW" : "CCW")"
            
        }
    }

    
}
