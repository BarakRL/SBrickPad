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
    
    case drive(channel: UInt8, cw: Bool, minPower: UInt8, maxPower: UInt8, easing: Easing)
        
    //MARK: - Helpers
    static func power(fromValue inValue: Float, minPower: UInt8, maxPower: UInt8, easing: Easing = .linear) -> (value: UInt8, isNegative: Bool) {
        
        //keep polarity, but calculate as UInt8
        let isNegative: Bool = (inValue < 0)
        let value = easing.curve(abs(inValue))
        
        //print("\(inValue) -> \(isNegative ? "-" : "+")\(value))")
        
        //protect (if min = 100, max = 50 -> min = 50)
        let minPower = min(maxPower, minPower)
        
        //normalize
        let relativePower = UInt(Float(maxPower - minPower) * value) + UInt(minPower)
        
        //protect and cast
        let power = UInt8(min(relativePower, UInt(0xFF)))
        return (value: power, isNegative: isNegative)
    }
    
    var name: String {
        
        switch self {
            
        case .drive(_,_,_,_,_):
            return "Drive"
            
        }
        
    }
    
    var description: String {
        
        switch self {
            
        case let .drive(channel, cw, minPower, maxPower, easing):
            return "Channel: \(channel), Power: \(minPower)-\(maxPower) \(cw ? "CW" : "CCW") \(easing.description)"
            
        }
    }

    enum Easing {
        
        case linear
        case easeIn
        case easeOut
        case easeInOut
        
        var curve: ((Float)->Float) {
            
            switch self {
            case .linear:
                return { $0 }
                
            case .easeIn:
                return { $0 * $0 }
                
            case .easeOut:
                return { $0 * (2 - $0) }
                
            case .easeInOut:
                return {
                    if $0 < 0.5 {
                        return 2 * $0 * $0
                    }
                    else {
                        return -1 + (4 - 2 * $0) * $0
                    }
                }
                
            }
        }
        
        var description: String {
            
            switch self {
            case .linear:       return "Linear"
            case .easeIn:       return "Ease In"
            case .easeOut:      return "Ease Out"
            case .easeInOut:    return "Ease In Out"
            }
        }
    }
}


