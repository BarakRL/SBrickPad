//
//  GameControllerButton.swift
//  SBrickPad
//
//  Created by Barak Harel on 4/30/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation

public enum GameControllerButton: String, Codable {
    
    enum Event: String, Codable {
        
        case pressed
        case released
        case valueChanged        
    }
    
    case up
    case down
    case left
    case right
    case start
    case select
    case buttonA
    case buttonB
    case buttonX
    case buttonY
    case leftShoulder
    case rightShoulder
    case leftTrigger
    case rightTrigger
    
    case leftThumbstickX
    case leftThumbstickY
    case rightThumbstickX
    case rightThumbstickY
    
    public var name: String {
        
        switch self {
        case .up:               return "Up"
        case .down:             return "Down"
        case .left:             return "Left"
        case .right:            return "Right"
        case .start:            return "Start"
        case .select:           return "Select"
        case .buttonA:          return "Button A"
        case .buttonB:          return "Button B"
        case .buttonX:          return "Button X"
        case .buttonY:          return "Button Y"
        case .leftShoulder:     return "Left Shoulder"
        case .rightShoulder:    return "Right Shoulder"
        case .leftTrigger:      return "Left Trigger"
        case .rightTrigger:     return "Right Trigger"
        case .leftThumbstickX:  return "Left Thumbstick X Axis"
        case .leftThumbstickY:  return "Left Thumbstick Y Axis"
        case .rightThumbstickX: return "Right Thumbstick X Axis"
        case .rightThumbstickY: return "Right Thumbstick Y Axis"
            
        }
    }
    
    public static let allButtons = [up, down, left, right, start, select,
                                    buttonA, buttonB, buttonX, buttonY,
                                    leftShoulder, rightShoulder, leftTrigger, rightTrigger,
                                    leftThumbstickX, leftThumbstickY, rightThumbstickX, rightThumbstickY]
}
