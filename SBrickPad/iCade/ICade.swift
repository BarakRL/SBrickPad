//
//  iCade.swift
//  SBrick-iOS
//
//  Created by Barak Harel on 4/3/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

public class ICadeButton {
    
    let button: GameControllerButton
    
    let pressKey: String
    let releaseKey: String
    
    init?(button: GameControllerButton) {
    
        guard let pressKey = ICadeButton.getPressKey(button: button), let releaseKey = ICadeButton.getReleaseKey(button: button) else { return nil }
    
        self.button = button
        self.pressKey = pressKey
        self.releaseKey = releaseKey
    }
    
    static func getPressKey(button: GameControllerButton) -> String? {
        
        switch button {
        case .up:               return "w"
        case .down:             return "x"
        case .left:             return "a"
        case .right:            return "d"
        case .start:            return "o"
        case .select:           return "l"
        case .buttonA:          return "h"
        case .buttonB:          return "u"
        case .buttonX:          return "y"
        case .buttonY:          return "j"
        case .leftShoulder:     return "k"
        case .rightShoulder:    return "i"
            
        default: return nil
        }
    }
    
    static func getReleaseKey(button: GameControllerButton) -> String? {
        
        switch button {
        case .up:               return "e"
        case .down:             return "z"
        case .left:             return "q"
        case .right:            return "c"
        case .start:            return "g"
        case .select:           return "v"
        case .buttonA:          return "r"
        case .buttonB:          return "f"
        case .buttonX:          return "t"
        case .buttonY:          return "n"
        case .leftShoulder:     return "p"
        case .rightShoulder:    return "m"
            
        default: return nil
        }
    }
    
    static func button(forPressKey pressKey: String) -> GameControllerButton? {
        
        for button in GameControllerButton.allButtons {
            
            if self.getPressKey(button: button) == pressKey {
                return button
            }
        }
        
        return nil
    }
    
    static func button(forReleaseKey releaseKey: String) -> GameControllerButton? {
        
        for button in GameControllerButton.allButtons {
            
            if self.getReleaseKey(button: button) == releaseKey {
                return button
            }
        }
        
        return nil
    }
}

public class ICade: NSObject {
    
    public class func pressCommands(action: Selector) -> [UIKeyCommand] {
        
        var pressCommands: [UIKeyCommand] = []
        
        for button in GameControllerButton.allButtons {
            if let iCadeButton = ICadeButton(button: button) {
                pressCommands.append(UIKeyCommand(input: iCadeButton.pressKey, modifierFlags: [], action: action))
            }
        }
        
        return pressCommands
    }
    
    public class func releaseCommands(action: Selector) -> [UIKeyCommand] {
        
        var releaseCommands: [UIKeyCommand] = []
        
        for button in GameControllerButton.allButtons {
            if let iCadeButton = ICadeButton(button: button) {
                releaseCommands.append(UIKeyCommand(input: iCadeButton.releaseKey, modifierFlags: [], action: action))
            }
        }
        
        return releaseCommands
    }
}
