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
        case valueChanged   = "value_changed"
    }
    
    case up             = "up"
    case down           = "down"
    case left           = "left"
    case right          = "right"
    case start          = "start"
    case select         = "select"
    case buttonA        = "button_a"
    case buttonB        = "button_b"
    case buttonX        = "button_x"
    case buttonY        = "button_y"
    case leftShoulder   = "left_shoulder"
    case rightShoulder  = "right_shoulder"
    case leftTrigger    = "left_trigger"
    case rightTrigger   = "right_trigger"
    
    case leftThumbstickX    = "left_thumbstick_x"
    case leftThumbstickY    = "left_thumbstick_y"
    case rightThumbstickX   = "right_thumbstick_x"
    case rightThumbstickY   = "right_thumbstick_y"
    
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
