//
//  GameController.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 4/30/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation

public enum GameControllerButton {
    
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
            
        }
    }
    
    public static let allButtons = [up, down, left, right, start, select,
                                    buttonA, buttonB, buttonX, buttonY,
                                    leftShoulder, rightShoulder, leftTrigger, rightTrigger]
}
