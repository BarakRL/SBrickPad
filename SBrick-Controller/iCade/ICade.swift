//
//  iCade.swift
//  SBrick-iOS
//
//  Created by Barak Harel on 4/3/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

public enum ICadeButton {
    
    case up
    case down
    case left
    case right
    case start
    case select
    case button1
    case button2
    case button3
    case button4
    case button5
    case button6
    
    public var pressKey: String {
        
        switch self {
        case .up:       return "w"
        case .down:     return "x"
        case .left:     return "a"
        case .right:    return "d"
        case .start:    return "o"
        case .select:   return "l"
        case .button1:  return "h"
        case .button2:  return "u"
        case .button3:  return "y"
        case .button4:  return "j"
        case .button5:  return "k"
        case .button6:  return "i"
        }
    }
    
    public var releaseKey: String {
        
        switch self {
        case .up:       return "e"
        case .down:     return "z"
        case .left:     return "q"
        case .right:    return "c"
        case .start:    return "g"
        case .select:   return "v"
        case .button1:  return "r"
        case .button2:  return "f"
        case .button3:  return "t"
        case .button4:  return "n"
        case .button5:  return "p"
        case .button6:  return "m"
        }
    }
    
    public var name: String {
        
        switch self {
        case .up:       return "Up"
        case .down:     return "Down"
        case .left:     return "Left"
        case .right:    return "Right"
        case .start:    return "Start"
        case .select:   return "Select"
        case .button1:  return "Button 1"
        case .button2:  return "Button 2"
        case .button3:  return "Button 3"
        case .button4:  return "Button 4"
        case .button5:  return "Button 5"
        case .button6:  return "Button 6"
        }
    }
    
    public init?(key: String) {
        
        for button in ICadeButton.allButtons {
            
            if button.pressKey == key || button.releaseKey == key {
                self = button
                return
            }
        }
            
        return nil
        
    }
    
    public static let allButtons = [up, down, left, right, start, select,
                                   button1, button2, button3, button4, button5, button6
                                   ]
}

public class ICade: NSObject {
    
    public class func pressCommands(action: Selector) -> [UIKeyCommand] {
        
        var pressCommands: [UIKeyCommand] = []
        
        for button in ICadeButton.allButtons {
            pressCommands.append(UIKeyCommand(input: button.pressKey, modifierFlags: [], action: action))
        }
        
        return pressCommands
    }
    
    public class func releaseCommands(action: Selector) -> [UIKeyCommand] {
        
        var releaseCommands: [UIKeyCommand] = []
        
        for button in ICadeButton.allButtons {
            releaseCommands.append(UIKeyCommand(input: button.releaseKey, modifierFlags: [], action: action))
        }
        
        return releaseCommands
    }
}
