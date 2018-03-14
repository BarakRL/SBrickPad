//
//  GameControllerValueActionEasing.swift
//  SBrickPad
//
//  Created by Barak Harel on 5/21/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation

enum GameControllerValueActionEasing: String, Codable {
    
    case linear     = "linear"
    case easeIn     = "ease_in"
    case easeOut    = "ease_out"
    case easeInOut  = "ease_in_out"
    
    static var allValues: [GameControllerValueActionEasing] = [.linear, .easeIn, .easeOut, .easeInOut]
    
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

